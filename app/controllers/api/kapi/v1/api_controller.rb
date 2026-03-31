# frozen_string_literal: true

class Api::Kapi::V1::ApiController < ActionController::API
  include Api::Jwtable

  helper_method :current_user

  def current_user(header = request.headers['Authorization'])
    token = header&.split&.last
    user_id = decode_token(token)
    User.find_by(id: user_id)
  end
end
