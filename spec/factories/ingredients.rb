# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    association :material
    association :product
    association :user

    quantity { 1 }
    total_cost { 1.0 }
  end
end
