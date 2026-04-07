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

    def access_token(user)
      JWT.encode({
                   access_token: user.id,
                   sub: user.email_address,
                   iat: Time.current.to_i,
                   exp: 15.minutes.from_now.to_i,
                   aud: 'http://api.kapi.com'
                 },
                 jwt_secret,
                 ALGORITHM)
    end

    def refresh_token(user)
      JWT.encode({
                   refresh_token: user.id,
                   exp: 7.days.from_now.to_i,
                   aud: 'http://api.kapi.com'
                 },
                 jwt_secret,
                 ALGORITHM)
    end

    def decode_token(token)
      payload, = JWT.decode(token, jwt_secret, true, decode_options)
      payload['access_token'] || payload['refresh_token']
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::InvalidAudError
      nil
    end

    def current_user(header = request.headers['Authorization'])
      token = header&.split&.last
      user_id = decode_token(token)
      User.find_by(id: user_id)
    end

    def authenticate_user!
      render_unauthorized_access unless current_user
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
