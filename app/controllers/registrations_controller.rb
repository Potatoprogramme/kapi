# frozen_string_literal: true

class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: t('.success')
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence.presence || t('.failure')
      render :new, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.expect(user: %i[email_address password password_confirmation])
  end
end
