Rails.application.routes.draw do
  root to: 'customers#index' # this will configure server to bring up index page when connecting to root path

  resources :customers
  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
