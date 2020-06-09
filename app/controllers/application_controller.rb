class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :set_locale

  private

    def set_locale
      if params[:locale].present?
        I18n.locale = params[:locale]
      else
        I18n.locale = I18n.default_locale
      end
    end

    def default_url_options(options = {})
      { locale: I18n.locale }
    end
end
