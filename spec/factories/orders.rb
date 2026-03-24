FactoryBot.define do
  factory :order do
    user { nil }
    order_total { "9.99" }
    payment_method { 1 }
    status { 1 }
  end
end
