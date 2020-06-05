class SwitchboardsController < ApplicationController
  # POST switchboards/welcome
  def welcome
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: '5', action: switchboards_representatives_path, timeout: 20) do |gather|
      alice_says(
        requester: gather,
        message: "Thanks for using Bug Your Congressman dot com.",
      )
      alice_says(
        requester: gather,
        message: "Please enter your 5 digit zipcode to get a list of representatives you can call.",
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
            message: "Press #{index+1} for #{congressman.name}.",
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
      message: "Please wait while we connect you to #{member.name}.",
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
      message: "We couldn't detect your zipcode, so we're connecting you to the main Congress switchboard in Washington, DC.",
    )
    response.dial(number: '2022243121')
    response.hangup

    render xml: response.to_s
  end

  private

    def alice_says(requester: , message:)
      requester.say(
        message: message,
        voice: 'alice'
      )
    end
end
