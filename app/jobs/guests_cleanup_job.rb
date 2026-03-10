# frozen_string_literal: true

class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting GuestsCleanupJob at #{Time.current}"
    Rails.logger.debug 'Job is working!'
  end
end
