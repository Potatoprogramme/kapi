# frozen_string_literal: true

json.extract! order,
              :id,
              :order_total,
              :payment_method,
              :status,
              :created_at,
              :updated_at
json.order_items do
  json.array! order.order_items do |item|
    json.item_id item.id
    json.product_id item.product_id
    json.item_name item.item_name
    json.quantity item.quantity.to_i
    json.cost_per_item item.cost_per_item.to_f
    json.total_cost item.item_total_cost
    json.created_at item.created_at
    json.updated_at item.updated_at
  end
end
