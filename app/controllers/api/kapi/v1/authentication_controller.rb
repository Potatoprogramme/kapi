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
      @access_token = refresh_access_token
      return render_error(status: :unauthorized, message: 'Invalid refresh token') unless @access_token

      render :refresh_token, status: :ok
    end
  end
end
