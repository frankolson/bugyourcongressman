class Switchboards::SelectChamberController < Switchboards::BaseController
  # POST switchboards/select_chamber
  def create
    @user_zipcode = params[:Digits]
  end
end
