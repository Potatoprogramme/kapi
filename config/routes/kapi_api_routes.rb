# frozen_string_literal: true

namespace :api, defaults: { format: :json } do
  namespace :kapi do
    namespace :v1 do
      resources :materials
    end
  end
end
