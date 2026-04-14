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

    def refresh
      @access_token = refresh_access_token
      render_error(status: :unauthorized, message: 'Invalid refresh token') unless @access_token
    end
  end
end
