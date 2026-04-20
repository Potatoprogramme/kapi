# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    association :product_category
    association :user

    name { Faker::Food.dish }
    status { :active }

    after(:build) do |product|
      next if product.thumbnail.attached?

      product.thumbnail.attach(
        io: StringIO.new('thumbnail'),
        filename: 'thumbnail.jpg',
        content_type: 'image/jpeg'
      )
    end

    trait :with_ingredients do
      after(:create) do |product|
        material_one = create(:material)
        material_two = create(:material)

        create(:ingredient,
               product: product,
               material: material_one,
               quantity: 10,
               total_cost: (10 * material_one.cost_per_unit).round(3))

        create(:ingredient,
               product: product,
               material: material_two,
               quantity: 20,
               total_cost: (20 * material_two.cost_per_unit).round(3))
      end
    end

    trait :with_costing do
      after(:create) do |product|
        create(:product_costing,
               product: product,
               overhead_percentage: 20,
               profit_margin_percentage: 20,
               selling_price: 200,
               direct_cost: 114.27,
               overhead_cost: 22.85,
               total_cost: 137.13,
               profit_margin_amount: 34.28)
      end
    end
  end
end
