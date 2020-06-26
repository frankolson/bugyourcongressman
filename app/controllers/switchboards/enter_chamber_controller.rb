class Switchboards::EnterChamberController < Switchboards::BaseController
  # POST switchboards/enter_chamber
  def create
    @user_zipcode = params[:Digits]
  end
end
