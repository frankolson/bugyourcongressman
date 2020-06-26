class Switchboards::RepresentativesController < Switchboards::BaseController
  # POST switchboards/representatives
  def create
    @user_zipcode = representatives_params[:zipcode]
    @chamber = params[:Digits]
    @congressmen = CivicInformation::Representative.where(
      address: @user_zipcode,
      roles: selected_chamber(params[:Digits])
    )
  end

  private
    def representatives_params
      params.require(:representatives).permit(:zipcode).tap do |given_parameters|
        given_parameters.require(:zipcode)
      end
    end
end
