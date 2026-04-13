# frozen_string_literal: true

json.message 'Product created successfully'
json.data do
  json.partial! 'product', { product: @product }
  json.ingredients do
    @product.ingredients.each do |ingredient|
      json.set! ingredient.id do
        json.partial! 'ingredient', ingredient: ingredient
      end
    end
  end

  json.product_costing do
    json.partial! 'product_costing', product_costing: @product.product_costing
  end
end
