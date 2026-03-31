# frozen_string_literal: true

module Api
  module Jwtable
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_api_user!
      after_action :clear_current_user
      helper_method :current_user
    end

    private

    def authenticate_api_user!
      token = jwt_from_header
      payload = decode_jwt(token)
      user = payload && User.find_by(id: payload['sub'] || payload['user_id'])
      return render(json: { error: 'Unauthorized' }, status: :unauthorized) unless user

      Current.user = user
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    def jwt_from_header
      auth = request.headers['Authorization']&.split
      return nil unless auth&.size == 2 && auth.first.to_s.downcase == 'bearer'

      auth.last
    end

    def decode_jwt(token)
      return nil unless token

      secret = ENV.fetch('JWT_SECRET') { Rails.application.secret_key_base }
      decoded, = JWT.decode(token, secret, true, algorithm: 'HS256')
      decoded
    end

    def current_user
      Current.user
    end

    def clear_current_user
      Current.user = nil
    end
  end
end