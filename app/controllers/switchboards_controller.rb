class SwitchboardsController < ApplicationController
  before_action :set_format

  helper SwitchboardsHelper

  # POST switchboards/welcome
  def welcome
  end

  # POST switchboards/enter_zipcode
  def enter_zipcode
    set_locale_after_prompt
  end

  # POST switchboards/representatives
  def representatives
    @user_zipcode = params[:Digits]
    @congressmen = CivicInformation::Representative.where(
      address: @user_zipcode,
      roles: ['legislatorLowerBody', 'legislatorUpperBody']
    )
  end

  # POST switchboards/dial
  def dial
    members_of_congress = CivicInformation::Representative.where(
      address: params[:zipcode],
      roles: ['legislatorLowerBody', 'legislatorUpperBody']
    )
    @congressman = members_of_congress[params[:Digits].to_i-1]
  end

  # POST switchboards/no_zipcode
  def no_zipcode
  end

  private

    def set_format
      request.format = :xml
    end

    def set_locale_after_prompt
      if params[:Digits] == '2'
        I18n.locale = :es
      else
        I18n.locale = I18n.default_locale
      end
    end
end
