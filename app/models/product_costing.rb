# frozen_string_literal: true

class ProductCosting < ApplicationRecord
  belongs_to :product
  validates :overhead_percentage, :profit_margin_percentage, :direct_cost, :overhead_cost,
            :total_cost, :profit_margin_amount, :selling_price, presence: true
  validate :costing_values_are_consistent

  def costing_values_are_consistent
    return if [direct_cost, overhead_percentage, profit_margin_percentage, overhead_cost, total_cost,
               profit_margin_amount].any?(&:nil?)

    # Avoid division by zero / negative denominator
    if profit_margin_percentage.to_d >= 100
      errors.add(:profit_margin_percentage, 'must be less than 100')
      return
    end

    expected_overhead_cost = (direct_cost.to_d * (overhead_percentage.to_d / 100)).round(2)
    expected_total_cost = (direct_cost.to_d + expected_overhead_cost).round(2)
    expected_recommended_selling = (expected_total_cost / (1 - (profit_margin_percentage.to_d / 100))).round(2)
    expected_profit_margin_amount = (expected_recommended_selling - expected_total_cost).round(2)

    return if overhead_cost.to_d.round(2) == expected_overhead_cost &&
              total_cost.to_d.round(2) == expected_total_cost &&
              profit_margin_amount.to_d.round(2) == expected_profit_margin_amount

    errors.add(:base, 'Costing values are inconsistent')
  end
end
