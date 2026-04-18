# frozen_string_literal: true

FactoryBot.define do
  factory :product_category do
    name { Faker::Coffee.origin }
    description { 'some description' }
  end
end
