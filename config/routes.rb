Rails.application.routes.draw do
  get 'orders/new'

  get 'orders/index'

  get 'orders/show'

  get 'orders/edit'

  root to: 'customers#index' # this will configure server to bring up index page when connecting to root path
  resources :customers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
