# frozen_string_literal: true

module Api::Kapi::V1
  class AuthenticationController < Api::Kapi::V1::ApiController
    def login
      if valid_login?
        render :token, status: :ok
      else
        render_error(status: :unauthorized, message: 'Invalid Email or Password')
      end
    end

    def logout
      if logout?
        render json: { message: 'Logged out successfully' }, status: :ok
      else
        render_error(status: :unauthorized, message: 'Invalid refresh token')
      end
    end

    def refresh
      @access_token = refresh_access_token
      return render_error(status: :unauthorized, message: 'Invalid refresh token') unless @access_token

      render :refresh_token, status: :ok
    end
  end
end
