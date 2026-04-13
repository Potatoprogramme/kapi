# frozen_string_literal: true

json.id ingredient.id
json.name ingredient.material.name
json.costing do
  json.id ingredient.ingredient_costing.id
  json.quantity ingredient.ingredient_costing.quantity.to_f
  json.total_cost ingredient.ingredient_costing.ingredient_total_cost.to_f
  json.created_at ingredient.ingredient_costing.created_at
  json.updated_at ingredient.ingredient_costing.updated_at
end
