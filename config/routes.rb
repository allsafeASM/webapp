Rails.application.routes.draw do
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resource :registration, path: 'sign-up', only: [:new, :create], path_names: { new: '' }
  resource :verification, only: [:show], param: :token

  # OmniAuth routes
  post '/auth/:provider', to: 'omniauth_callbacks#passthru', as: :auth
  match '/auth/:provider/callback', to: 'omniauth_callbacks#callback', via: [:get, :post]
  get '/auth/failure', to: 'omniauth_callbacks#failure'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
