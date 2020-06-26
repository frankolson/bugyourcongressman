class Switchboards::EnterZipcodeController < Switchboards::BaseController
  # POST switchboards/enter_zipcode
  def create
    set_locale_after_prompt
  end

  private
    def set_locale_after_prompt
      if params[:Digits] == '2'
        I18n.locale = :es
      else
        I18n.locale = I18n.default_locale
      end
    end
end
