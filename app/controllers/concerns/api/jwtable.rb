# frozen_string_literal: true

module Api
  module Jwtable
    extend ActiveSupport::Concern

    def generate_token(user)
      JWT.encode({
                   user_id: user.id,
                   exp: 24.hours.from_now.to_i
                 },
                 ENV.fetch('SECRET_KEY_BASE', nil),
                 'HS256')
    end

    def decode_token(token)
      decoded_token = JWT.decode(token, ENV.fetch('SECRET_KEY_BASE', nil), true, { algorithm: 'HS256' })
      decoded_token[0]['user_id']
    rescue JWT::DecodeError
      nil
    end

    def current_user(header = request.headers['Authorization'])
      token = header&.split&.last
      user_id = decode_token(token)
      User.find_by(id: user_id)
    end

    def authenticate_user!
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
    end
  end
end
