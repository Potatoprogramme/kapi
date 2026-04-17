# frozen_string_literal: true

json.id ingredient.id
json.name ingredient.material.name
json.costing do
  json.quantity ingredient.quantity.to_f
  json.total_cost ingredient.total_cost.to_f
  json.created_at ingredient.created_at
  json.updated_at ingredient.updated_at
end
