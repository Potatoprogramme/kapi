# frozen_string_literal: true

class ProductCosting < ApplicationRecord
  belongs_to :product
  validates :overhead_percentage, :profit_margin_percentage, :direct_cost, :overhead_cost,
            :total_cost, :profit_margin_amount, :selling_price, presence: true
  validate :costing_values_are_consistent

  def costing_values_are_consistent
    overhead_cost = (direct_cost * (overhead_percentage / 100)).to_f.round(2)
    total_cost = (overhead_cost + direct_cost).to_f.round(2)
    recommended_selling = (total_cost / (1 - (profit_margin_percentage / 100))).to_f.round(2)
    profit_margin_amount = (recommended_selling - total_cost).to_f.round(2)
    unless overhead_cost == self.overhead_cost &&
           total_cost == self.total_cost &&
           profit_margin_amount == self.profit_margin_amount
      errors.add(:base, 'Costing values are inconsistent')
    end
  end
end
