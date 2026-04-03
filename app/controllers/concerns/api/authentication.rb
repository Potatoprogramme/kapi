# frozen_string_literal: true

module Api::Authentication
  extend ActiveSupport::Concern

  def validate_login
    user = User.find_by(email_address: user_params[:email_address])
    if user&.authenticate(user_params[:password])
      @token = generate_token(user)
      render :token, status: :ok
    else
      render_error(status: :unauthorized, message: 'Invalid Email or Password')
    end
  end

  private

  def user_params
    params.expect(user: %i[email_address password])
  end
end
