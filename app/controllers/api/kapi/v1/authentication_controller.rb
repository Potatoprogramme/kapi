# frozen_string_literal: true

module Api::Kapi::V1
  class AuthenticationController < Api::Kapi::V1::ApiController
    def login
      validate_login
    end

    def logout
      logout_user
    end

    def refresh
      refresh_access_token
    end
  end
end
