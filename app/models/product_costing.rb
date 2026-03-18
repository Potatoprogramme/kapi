# frozen_string_literal: true

class ProductCosting < ApplicationRecord
  belongs_to :product
  validates :overhead_percentage, :profit_margin_percentage, :direct_cost, :overhead_cost,
            :total_cost, :profit_margin_amount, :selling_price, presence: true
end
