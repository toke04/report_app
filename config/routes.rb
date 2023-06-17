Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
    # registrations: "users/registrations"
  }
  resources :reports
  root to: "reports#index"
end
