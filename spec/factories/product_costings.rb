# frozen_string_literal: true

FactoryBot.define do
  factory :product_costing do
    association :product

    overhead_percentage { 20 }
    profit_margin_percentage { 20 }
    direct_cost { 114.27 }
    overhead_cost { 22.85 }
    total_cost { 137.13 }
    profit_margin_amount { 34.28 }
    selling_price { 200 }
  end
end
