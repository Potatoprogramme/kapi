# frozen_string_literal: true

module Api
  module Authentication
    extend ActiveSupport::Concern

    def valid_login?
      user = User.find_by(email_address: user_params[:email_address])
      return false unless user&.authenticate(user_params[:password])

      @tokens = generate_tokens(user)
    end

    private

    def user_params
      params.expect(user: %i[email_address password])
    end
  end
end
