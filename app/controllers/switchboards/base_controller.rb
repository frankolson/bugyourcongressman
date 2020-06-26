class Switchboards::BaseController < ApplicationController
  before_action :set_format

  helper SwitchboardsHelper

  def set_format
    request.format = :xml
  end

  def selected_chamber(user_selection)
    ['legislatorUpperBody', 'legislatorLowerBody'][user_selection.to_i - 1]
  end
end