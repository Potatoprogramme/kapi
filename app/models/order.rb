# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  validates :order_total, presence: true
  has_many :order_items, dependent: :destroy

  enum :payment_method, { cash: 0, gcash: 1, card: 2, maya: 3 }
  enum :status, { pending: 0, completed: 1, voided: 2 }
end
