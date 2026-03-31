# frozen_string_literal: true

namespace :api, default: { format: :json } do
  namespace :kapi do
    namespace :v1 do
      post 'auth/login', to: 'authentication#login'
      resources :materials
    end
  end
end
