# frozen_string_literal: true

class Api::Kapi::V1::AuthenticationController < Api::Kapi::V1::ApiController
  def login
    validate_login
  end
end
