# frozen_string_literal: true

class Api::Kapi::V1::AuthenticationController < Api::Kapi::V1::ApiController
  def login
    user = User.find_by(email_address: user_params[:email_address])
    if user&.authenticate(user_params[:password])
      token = generate_token(user)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.expect(user: %i[email_address password])
  end
end
