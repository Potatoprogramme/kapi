# frozen_string_literal: true

FactoryBot.define do
  factory :material do
    name { Faker::Food.ingredient }
    cost { Faker::Number.decimal(l_digits: 2, r_digits: 3) }
    quantity { Faker::Number.between(from: 1, to: 100) }
    unit { Material::VALID_UNITS.sample }
    cost_per_unit { (cost / quantity).round(3) }
  end
end
