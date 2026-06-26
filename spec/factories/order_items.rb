FactoryBot.define do
  factory :order_item do
    association :order
    association :product
    item_name { 'MyText' }
    quantity { '9.99' }
    cost_per_item { '9.99' }
    item_total_cost { '9.99' }
  end
end
