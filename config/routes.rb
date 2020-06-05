Rails.application.routes.draw do
  post 'switchboards/welcome', to: 'switchboards#welcome'
  post 'switchboards/representatives', to: 'switchboards#representatives'
  post 'switchboards/no_zipcode', to: 'switchboards#no_zipcode'
  post 'switchboards/dial', to: 'switchboards#dial'

  get 'pages/about'
  root 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
