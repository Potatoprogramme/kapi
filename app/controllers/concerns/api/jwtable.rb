# frozen_string_literal: true

module Api
  module Jwtable
    extend ActiveSupport::Concern

    ALGORITHM = 'HS256'
    def generate_tokens(user)
      {
        access_token: access_token(user),
        refresh_token: refresh_token(user)
      }
    end

    def decode_token(token)
      decoded = JWT.decode(token, jwt_secret, true, decode_options)
      decoded[0]
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::InvalidAudError
      nil
    end

    def access_token(user)
      JWT.encode({
                   user_id: user.id,
                   type: 'access',
                   sub: user.email_address,
                   iat: Time.current.to_i,
                   exp: 60.minutes.from_now.to_i,
                   aud: 'http://api.kapi.com'
                 },
                 jwt_secret,
                 ALGORITHM)
    end

    def refresh_token(user)
      JWT.encode({
                   user_id: user.id,
                   type: 'refresh',
                   iat: Time.current.to_i,
                   exp: 7.days.from_now.to_i,
                   aud: jwt_audience
                 },
                 jwt_secret,
                 ALGORITHM)
    end

    def current_user(header = request.headers['Authorization'])
      token = header&.split&.last
      payload = decode_token(token)
      return render_error(status: :unauthorized, message: 'Invalid token') unless payload['type'] == 'access'

      User.find_by(id: payload['user_id']) if payload&.key?('user_id')
    end

    def authenticate_user!
      render_unauthorized_access unless current_user
    end

    def refresh_access_token
      token = cookies[:refresh_token]
      return nil if token.blank?

      payload, = JWT.decode(token, jwt_secret, true, decode_options)
      return nil unless payload['type'] == 'refresh'

      user = User.find_by(id: payload['user_id'])
      return nil unless user

      access_token(user)
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::InvalidAudError
      nil
    end

    private

    def jwt_secret
      ENV.fetch('SECRET_KEY_BASE')
    end

    def decode_options
      {
        algorithm: ALGORITHM,
        verify_aud: true,
        aud: jwt_audience
      }
    end

    def jwt_audience
      'http://api.kapi.com'
    end
  end
end
