Rails.application.routes.draw do
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resource :registration, path: "sign-up", only: [ :new, :create ], path_names: { new: "" } # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  resource :verification, only: [ :show ], param: :token
  resource :account, only: [ :show ]
  resources :domains do
    resources :enumeration_scans, only: [ :index, :show ] do
      resources :enumeration_scan_results, only: [ :index, :show ]
    end
    resources :vulnerability_scans, only: [ :index, :show ] do
      resources :vulnerability_scan_results, only: [ :index, :show ]
    end
  end

  # OmniAuth routes
  match "/auth/:provider/callback", to: "omniauth_callbacks#callback", via: [ :get, :post ]
  get "/auth/failure", to: "omniauth_callbacks#failure"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "domains#index"
end
