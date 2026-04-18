# frozen_string_literal: true

json.orders do
  json.array! @orders do |order|
    json.partial! 'order', order: order
  end
end
