# frozen_string_literal: true

module API
  module KAPI
    module V1
      class APIController < ActionController::API
        include API::Errorable   # Error handling methods
        include API::Jwtable     # JWT encode/decode methods

        # logic here..
      end
    end
  end
end
