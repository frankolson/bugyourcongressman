class QualifiedImmunityController < ApplicationController
  # POST qualified_immunity/welcome
  def welcome
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: '1', action: qualified_immunity_menu_path) do |gather|
      gather.say(
        message: "Thanks for calling the E T Phone Home Service. Please press 1 for directions. Press 2 for a list of planets to call.",
        timeout: 10
      )
    end

    render xml: response.to_s
  end

  # GET qualified_immunity/menu
  def menu
    user_selection = params[:Digits]

    case user_selection
    when "1"
      @output = "To get to your extraction point, get on your bike and go down
        the street. Then Left down an alley. Avoid the police cars. Turn left
        into an unfinished housing development. Fly over the roadblock. Go
        passed the moon. Soon after you will see your mother ship."
      twiml_say(@output, true)
    when "2"
      list_planets
    else
      @output = "Returning to the main menu."
      twiml_say(@output)
    end
  end

  # GET/POST qualified_immunity/planets
  def planets
    user_selection = params[:Digits]

    case user_selection
    when "2"
      twiml_dial("+12024173378")
    when "3"
      twiml_dial("+12027336386")
    when "4"
      twiml_dial("+12027336637")
    else
      @output = "Returning to the main menu."
      twiml_say(@output)
    end
  end

  private

    def list_planets
      message = "To call the planet Broh doe As O G, press 2. To call the planet
      DuhGo bah, press 3. To call an oober asteroid to your location, press 4. To
      go back to the main menu, press the star key."

      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.gather(num_digits: '1', action: qualified_immunity_planets_path) do |gather|
          gather.say(message: message, voice: 'alice', language: 'en-GB', loop: 3)
        end
      end

      render xml: response.to_s
    end

    def twiml_say(phrase, exit = false)
      # Respond with some TwiML and say something.
      # Should we hangup or go back to the main menu?
      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.say(message: phrase, voice: 'alice', language: 'en-GB')
        if exit
          r.say(message: "Thank you for calling the ET Phone Home Service - the
          adventurous alien's first choice in intergalactic travel.")
          r.hangup
        else
          r.redirect(welcome_path)
        end
      end

      render xml: response.to_s
    end

    def twiml_dial(phone_number)
      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.dial(number: phone_number)
      end

      render xml: response.to_s
    end
end
