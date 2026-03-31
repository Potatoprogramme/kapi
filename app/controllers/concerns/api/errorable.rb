# frozen_string_literal: true

module Api
  module Errorable
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content
      rescue_from ActiveRecord::RecordNotUnique, with: :render_conflict
      rescue_from ActionController::ParameterMissing, with: :render_bad_request
      rescue_from Pundit::NotAuthorizedError, with: :render_forbidden if defined?(Pundit)
      rescue_from StandardError, with: :render_internal_server_error unless Rails.env.local?
    end

    private

    def render_error(status:, message:, errors: nil, meta: nil)
      payload = { success: false, error: { message: message } }
      payload[:error][:errors] = errors if errors.present?
      payload[:meta] = meta if meta.present?
      render json: payload, status: status
    end

    def render_not_found(exception)
      render_error(status: :not_found, message: exception.message)
    end

    def render_unprocessable_content(exception)
      render_error(
        status: :unprocessable_entity,
        message: exception.record.errors.full_messages.first || exception.message,
        errors: exception.record&.errors&.to_hash
      )
    end

    def render_conflict(exception)
      render_error(status: :conflict, message: exception.message)
    end

    def render_bad_request(exception)
      render_error(status: :bad_request, message: exception.message)
    end

    def render_forbidden(exception)
      render_error(status: :forbidden, message: exception.message)
    end

    def render_internal_server_error(exception)
      Rails.logger.error(exception)
      render_error(status: :internal_server_error, message: 'Internal server error')
    end
  end
end
