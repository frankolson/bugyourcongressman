class SwitchboardsController < ApplicationController
  # POST switchboards/welcome
  def welcome
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: '1', action: switchboards_enter_zipcode_path, timeout: 20, actionOnEmptyResult: true) do |gather|
      alice_says(
        requester: gather,
        message: t('.intro'),
      )
      alice_says(
        requester: gather,
        message: t('.language_prompt'),
        language: :es
      )
    end

    render xml: response.to_s
  end

  # POST switchboards/enter_zipcode
  def enter_zipcode
    set_locale_after_prompt
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: '5', action: switchboards_representatives_path, timeout: 20) do |gather|
      alice_says(
        requester: gather,
        message: t('.zipcode_prompt'),
      )
    end

    render xml: response.to_s
  end

  # POST switchboards/representatives
  def representatives
    user_zipcode = params[:Digits]
    congressmen = CivicInformation::Representative.where(address: user_zipcode)

    response = Twilio::TwiML::VoiceResponse.new
    if congressmen.any?
      response.gather(num_digits: '1', action: switchboards_dial_path(zipcode: user_zipcode), timeout: 20) do |gather|
        congressmen.each_with_index do |congressman, index|
          alice_says(
            requester: response,
            message: t('.prompt', digit: index + 1, name: congressman.name),
          )
        end
      end
    else
      response.redirect(switchboards_no_zipcode_path)
    end

    render xml: response.to_s
  end

  # POST switchboards/dial
  def dial
    user_zipcode = params[:zipcode] # somehow need to persist this between representatives and dial
    members_of_congress = CivicInformation::Representative.where(address: user_zipcode)
    member = members_of_congress[params[:Digits].to_i-1]

    response = Twilio::TwiML::VoiceResponse.new
    alice_says(
      requester: response,
      message: t('.instructions', name: member.name),
    )
    response.dial(number: member.phones.first)
    response.hangup

    render xml: response.to_s
  end

  # POST switchboards/no_zipcode
  def no_zipcode
    response = Twilio::TwiML::VoiceResponse.new
    alice_says(
      requester: response,
      message: t('.description'),
    )
    response.dial(number: '2022243121')
    response.hangup

    render xml: response.to_s
  end

  private

    def alice_says(requester: , message:, language: nil)
      requester.say(
        message: message,
        voice: 'alice',
        language: language || I18n.locale
      )
    end

    def set_locale_after_prompt
      if params[:Digits] == '2'
        I18n.locale = :es
      else
        I18n.locale = I18n.default_locale
      end
    end
end
