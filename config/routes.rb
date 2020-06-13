Rails.application.routes.draw do
  post 'switchboards/welcome', to: 'switchboards#welcome'
  post 'switchboards/enter_zipcode', to: 'switchboards#enter_zipcode'

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    post 'switchboards/enter_type', to: 'switchboards#enter_type'
    post 'switchboards/representatives', to: 'switchboards#representatives'
    post 'switchboards/no_zipcode', to: 'switchboards#no_zipcode'
    post 'switchboards/dial', to: 'switchboards#dial'

    get 'pages/about'
    root 'pages#home'
  end
  # match '*path', to: redirect("/#{I18n.default_locale}/%{path}"), via: :all,
  #   constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  # match '', to: redirect("/#{I18n.default_locale}"), via: :get
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
