# frozen_string_literal: true

module Api
  module Jwtable
    extend ActiveSupport::Concern

    def generate_token(user)
      JWT.encode({
                   user_id: user.id,
                   sub: user.email_address,
                   iat: Time.current.to_i,
                   exp: 24.hours.from_now.to_i,
                   aud: 'http://api.kapi.com'
                 },
                 ENV.fetch('SECRET_KEY_BASE', nil),
                 'HS256')
    end

    def decode_token(token)
      payload, = JWT.decode(token, jwt_secret, true, decode_options)
      payload['user_id']
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
        algorithm: 'HS256',
        verify_aud: true,
        aud: jwt_audience
      }
    end

    def jwt_audience
      'http://api.kapi.com'
    end
  end
end
