Rails.application.routes.draw do
  namespace :api do
    scope :v1 do            
      mount_devise_token_auth_for 'User', at: 'auth'
    end
    namespace :v1 do            
      resources :direct_uploads, only: [:create]
    end
  end
end