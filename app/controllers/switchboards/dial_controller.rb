class Switchboards::DialController < Switchboards::BaseController
  # POST switchboards/dial
  def create
    members_of_congress = CivicInformation::RepresentativesResource.where(
      address: dial_params[:zipcode],
      roles: selected_chamber(dial_params[:chamber])
    ).officers
    @congressman = members_of_congress[params[:Digits].to_i - 1]
  end

  private
    def dial_params
      params.require(:dial).permit(:zipcode, :chamber).tap do |given_parameters|
        given_parameters.require([:zipcode, :chamber])
      end
    end
end
