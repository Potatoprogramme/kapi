# frozen_string_literal: true

FactoryBot.define do
  factory :product_category do
    association :user

    name { Faker::Coffee.origin }
    description { 'some description' }
  end
end
