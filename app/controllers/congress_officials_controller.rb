class CongressOfficialsController < ApplicationController
  def index
    @officials = nil

    if params[:congress_official].present?
      @officials = CivicInformation::RepresentativesResource.where(
        address: search_params[:address],
        roles: selected_chamber(search_params[:chamber]),
        levels: ['country']
      ).officials
    end
  end

  private

    def search_params
      params.require(:congress_official).permit(:address, :chamber)
    end

    def selected_chamber(chamber)
      case chamber
      when 'House'
        ['legislatorLowerBody']
      when 'Senate'
        ['legislatorUpperBody']
      else
        params[:congress_official][:chamber] = 'Both'
        ['legislatorLowerBody', 'legislatorUpperBody']
      end
    end
end
