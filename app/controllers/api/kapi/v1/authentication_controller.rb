# frozen_string_literal: true

module Api::Kapi::V1
  class AuthenticationController < Api::Kapi::V1::ApiController
    def login
      validate_login
    end
  end
end
