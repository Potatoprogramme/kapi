# frozen_string_literal: true

json.partial! 'product', { product: @product, include_ingredients: true }
json.ingredients do
  @product.ingredients.each do |ingredient|
    json.set! ingredient.id do
      json.partial! 'ingredient', ingredient: ingredient
    end
  end
end
