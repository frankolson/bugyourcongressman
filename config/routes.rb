Rails.application.routes.draw do
  post 'switchboards/welcome', to: 'switchboards#welcome'
  post 'switchboards/enter_zipcode', to: 'switchboards#enter_zipcode'

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'pages#home'

    get 'about-us', to: 'pages#about_us', as: :about_us
    get 'about-qualified-immunity', to: 'pages#about_qualified_immunity',
      as: :about_qualified_immunity
    get 'about-congress', to: 'pages#about_congress', as: :about_congress

    post 'switchboards/enter_chamber', to: 'switchboards#enter_chamber'
    post 'switchboards/representatives', to: 'switchboards#representatives'
    post 'switchboards/no_zipcode', to: 'switchboards#no_zipcode'
    post 'switchboards/dial', to: 'switchboards#dial'

  end
  # match '*path', to: redirect("/#{I18n.default_locale}/%{path}"), via: :all,
  #   constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  # match '', to: redirect("/#{I18n.default_locale}"), via: :get
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
