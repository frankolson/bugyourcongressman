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

  # POST switchboards/enter_chamber
  def enter_chamber
    @user_zipcode = params[:Digits]
  end

  # POST switchboards/representatives
  def representatives
    @user_zipcode = representatives_params[:zipcode]
    @chamber = selected_chamber(params[:Digits])
    @congressmen = CivicInformation::Representative.where(
      address: @user_zipcode,
      roles: @chamber
    )
  end

  # POST switchboards/dial
  def dial
    members_of_congress = CivicInformation::Representative.where(
      address: dial_params[:zipcode],
      roles: selected_chamber(params[:chamber])
    )
    @congressman = members_of_congress[params[:Digits].to_i-1]
  end

  # POST switchboards/no_zipcode
  def no_zipcode
  end

  private
    def representatives_params
      params.require(:representatives).permit(:zipcode).tap do |given_parameters|
        given_parameters.require(:zipcode)
      end
    end

    def dial_params
      params.require(:dial).permit(:zipcode, :chamber).tap do |given_parameters|
        given_parameters.require([:zipcode, :chamber])
      end
    end

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

    def selected_chamber(user_selection)
      user_selection == '1' ? 'legislatorUpperBody' : 'legislatorLowerBody'
    end
end
