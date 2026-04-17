# frozen_string_literal: true

module Api
  module Kapi
    module V1
      class ApiController < ActionController::API
        include Api::Jwtable
        include Api::Errorable
        include Api::Authentication
      end
    end
  end
end
