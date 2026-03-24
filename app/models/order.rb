# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  validates :order_total, presence: true

  enum :payment_method, { cash: 0, gcash: 1, card: 2, maya: 3 }, default: :cash
  enum :status, { pending: 0, completed: 1, voided: 2 }, default: :pending
end
