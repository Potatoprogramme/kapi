# frozen_string_literal: true

json.products do
  json.array! @products do |product|
    json.partial! 'product', { product: product, include_ingredients: false }
  end
end
