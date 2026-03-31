# frozen_string_literal: true

Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: '/jobs'
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'home#index'

  resource :registrations, only: %i[new create]
  resources :materials
  resources :products do
    member do
      patch :soft_delete
    end
  end
  resources :product_categories
  resources :orders, except: %i[edit update destroy] do
    member do
      patch :complete
      patch :void
    end
  end

  # API routes
  draw :kapi_api_routes
end
