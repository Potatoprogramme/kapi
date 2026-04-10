# frozen_string_literal: true

namespace :api, default: { format: :json } do
  namespace :kapi do
    namespace :v1 do
      scope :auth, controller: 'authentication' do
        post 'login', to: 'login'
        post 'logout', to: 'logout'
        post 'refresh', to: 'refresh'
      end
      post 'register/user', to: 'registration#create'
      resources :materials, only: %i[index show create update destroy]
      resources :product_categories, only: %i[index show create update destroy]
      resources :products
    end
  end
end
