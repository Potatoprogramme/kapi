# frozen_string_literal: true

namespace :api, default: { format: :json } do
  namespace :kapi do
    namespace :v1 do
      post 'auth/login', to: 'authentication#login'
      post 'auth/logout', to: 'authentication#logout'
      post 'register/user', to: 'registration#create'
      resources :materials, only: %i[index show create update destroy]
    end
  end
end
