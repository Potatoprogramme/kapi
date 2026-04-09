# frozen_string_literal: true

FactoryBot.define do
  factory :product_category do
    name { Faker::Name }
    description { 'some description' }
  end
end
