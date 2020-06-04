Rails.application.routes.draw do
  match 'qualified_immunity/welcome', to: 'qualified_immunity#welcome',
    via: [:get, :post], as: :qualified_immunity_welcome
  match 'qualified_immunity/menu', to: 'qualified_immunity#menu',
    via: [:get, :post], as: :qualified_immunity_menu
  match 'qualified_immunity/planets', to: 'qualified_immunity#planets',
    via: [:get, :post], as: :qualified_immunity_planets
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
