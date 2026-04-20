FactoryBot.define do
  factory :order do
    association :user
    order_total { '9.99' }
    payment_method { :gcash }
    status { :pending }
  end
end
