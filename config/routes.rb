# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :cart_products
  resources :product_images
  resources :product_reviews
  resources :product_categories
  resources :payments
  resources :order_items
  resources :order_states
  resources :user_addresses
  resources :user_roles
  resources :reports
  resource :cart, only: %i[show destroy] do
    post 'add_product/:product_id', to: 'carts#add_product', as: 'add_product'
    post 'update_quantity/:product_id', to: 'carts#update_quantity', as: 'update_quantity'
    post 'remove_product/:product_id', to: 'carts#remove_product', as: 'remove_product'
    # Nuevas rutas para los usuarios registrados
    delete 'remove2/:product_id', to: 'carts#remove_product2', as: 'remove_product2'
    patch 'update_quantity2/:product_id', to: 'carts#update_quantity2', as: 'update_quantity2'
    # Rutas para el pago
    post 'checkout', to: 'carts#checkout', as: 'checkout_post'
    get 'checkout', to: 'carts#checkout', as: 'checkout'
    get 'payment_confirmation', to: 'carts#payment_confirmation', as: 'payment_confirmation'
  end
  # get 'cart/payment_method/:cart_id', to: 'payment_methods#new', as: 'payment_method_cart'

  resources :products
  resources :orders
  resources :users
  resources :categories
  # En config/routes.rb

  resources :payment_methods # , only: [:index, :create]

  # Otras rutas necesarias

  resources :payment_states
  resources :roles
  resources :states
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
