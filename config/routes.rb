require "sidekiq/web"

Rails.application.routes.draw do
  authenticated :admin do
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  namespace :admins do
    resources :posts do
      resources :comments
    end
  end

  namespace :users do
    resource :profile, only: [:show, :edit, :update], controller: :profile
    resources :posts do
      resources :comments
    end
  end

  namespace :api do
    namespace :users do
      post "sign_in", to: "sessions#create"
    end
    resource :me, only: [:show], controller: :me
    namespace :v1 do
      resources :posts, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "users/posts#index"
end
