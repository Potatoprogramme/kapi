# frozen_string_literal: true

module Api::Kapi::V1
  class RegistrationController < Api::Kapi::V1::ApiController
    def create
      @user = User.new(user_params)
      @user.save!
      render :create, status: :ok
    end

    private

    def user_params
      params.expect(user: %i[email_address password password_confirmation])
    end
  end
end
