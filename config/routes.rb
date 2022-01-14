Rails.application.routes.draw do
  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/registrations'
      }
    end
    namespace :v1 do
      resources :pictures, only: [:create, :index, :show]
    end
  end
end