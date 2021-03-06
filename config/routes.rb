Rails.application.routes.draw do
  namespace :switchboards do
    resource :welcome,       controller: :welcome,       only: :create
    resource :enter_zipcode, controller: :enter_zipcode, only: :create
  end

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'pages#home'

    get 'about-qualified-immunity', to: 'pages#about_qualified_immunity',
      as: :about_qualified_immunity
    get 'about-congress', to: 'pages#about_congress', as: :about_congress

    resources :congress_officials, only: :index

    namespace :switchboards do
      resource :select_chamber,     controller: :select_chamber,     only: :create
      resource :select_congressman, controller: :select_congressman, only: :create
      resource :invalid_zipcode,    controller: :invalid_zipcode,    only: :create
      resource :dial,               controller: :dial,               only: :create
    end
  end
  # match '*path', to: redirect("/#{I18n.default_locale}/%{path}"), via: :all,
  #   constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  # match '', to: redirect("/#{I18n.default_locale}"), via: :get
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
