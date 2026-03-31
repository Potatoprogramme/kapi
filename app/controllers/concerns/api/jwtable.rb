# frozen_string_literal: true

module Api
  module Jwtable
    extend ActiveSupport::Concern

    def generate_token(user)
      JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, ENV.fetch('SECRET_KEY_BASE', nil))
    end

    def decode_token(token)
      decoded = JWT.decode(token, ENV.fetch('SECRET_KEY_BASE', nil), true, algorithm: 'HS256')
      decoded.first['user_id']
    rescue JWT::DecodeError
      nil
    end
  end
end
