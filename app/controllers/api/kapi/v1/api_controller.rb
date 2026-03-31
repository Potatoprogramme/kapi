# frozen_string_literal: true

class Api::Kapi::V1::ApiController < ActionController::API
  include Api::Errorable
  include Api::Jwtable
end
