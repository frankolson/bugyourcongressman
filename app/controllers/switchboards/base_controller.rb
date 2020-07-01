class Switchboards::BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :set_format

  helper SwitchboardsHelper

  def set_format
    request.format = :xml
  end

  def selected_chamber(user_selection)
    ['legislatorUpperBody', 'legislatorLowerBody'][user_selection.to_i - 1]
  end
end