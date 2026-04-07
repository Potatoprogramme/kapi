# frozen_string_literal: true

module Api::Authentication
  extend ActiveSupport::Concern

  def validate_login
    user = User.find_by(email_address: user_params[:email_address])
    if user&.authenticate(user_params[:password])
      @tokens = generate_tokens(user)
      refresh_token_cookie(@tokens[:refresh_token])
      render :token, status: :ok
    else
      render_error(status: :unauthorized, message: 'Invalid Email or Password')
    end
  end

  def logout_user
    token = request.headers['Authorization']&.split&.last
    if token
      cookies.delete(:refresh_token, httponly: true, secure: Rails.env.production?, same_site: :lax)
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render_error(status: :bad_request, message: 'No token provided')
    end
  end

  private

  def refresh_token_cookie(refresh_token)
    cookies[:refresh_token] = {
      value: refresh_token,
      httponly: true,
      secure: Rails.env.production?,
      expires: 7.days.from_now
    }
  end

  def user_params
    params.expect(user: %i[email_address password])
  end
end
