# frozen_string_literal: true

module Api
  module Authentication
    extend ActiveSupport::Concern

    def valid_login?
      user = User.find_by(email_address: user_params[:email_address])
      return false unless user&.authenticate(user_params[:password])

      @tokens = generate_tokens(user)
      refresh_token_cookie(@tokens[:refresh_token])
    end

    def logout?
      token = request.headers['Authorization']&.split&.last
      return false unless token

      cookies.delete(:refresh_token, httponly: true, secure: Rails.env.production?, same_site: :lax)
    end

    private

    def refresh_token_cookie(refresh_token)
      cookies[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        secure: Rails.env.production?,
        expires: 7.days.from_now
      }
    end

    def user_params
      params.expect(user: %i[email_address password])
    end
  end
end
