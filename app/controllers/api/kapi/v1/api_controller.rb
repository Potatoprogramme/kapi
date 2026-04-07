# frozen_string_literal: true

class Api::Kapi::V1::ApiController < ActionController::API
  include Api::Jwtable
  include Api::Errorable
  include Api::Authentication
  include ActionController::Cookies
end
