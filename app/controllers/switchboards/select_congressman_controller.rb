class Switchboards::SelectCongressmanController < Switchboards::BaseController
  # POST switchboards/select_congressman
  def create
    @user_zipcode = select_congressman_params[:zipcode]
    @chamber = params[:Digits]
    @congressmen = CivicInformation::Representative.where(
      address: @user_zipcode,
      roles: selected_chamber(params[:Digits])
    )
  end

  private
    def select_congressman_params
      params.require(:select_congressman).permit(:zipcode).tap do |given_parameters|
        given_parameters.require(:zipcode)
      end
    end
end
