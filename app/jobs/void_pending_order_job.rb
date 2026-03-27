# frozen_string_literal: true

class VoidPendingOrderJob < ApplicationJob
  queue_as :default

  def perform
    pending_order = Order.where(status: :pending).where(created_at: ...1.hour.ago)

    pending_order.each do |order|
      order.update(status: :voided)
    end
  end
end
