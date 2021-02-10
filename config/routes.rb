Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  defaults format: :json do
    namespace :api do
      namespace :v1 do
        resources :baking_slots
        resources :orders
        resources :products
        resources :users
      end
    end
  end
end
