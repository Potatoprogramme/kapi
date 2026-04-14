# frozen_string_literal: true

module Products
  class CreateProduct
    include Interactor

    def call
      ActiveRecord::Base.transaction do
        create_product!
        create_ingredients!
        create_product_costing!
      end
      context.product = @product
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(error: e.record.errors.full_messages.to_sentence)
    end

    private

    def product_params
      context.product_params.to_h
    end

    def ingredient_params
      context.ingredient_create_params.to_h
    end

    def product_costing_params
      context.product_costing_params.to_h
    end

    def create_product!
      @product = Product.new(name: product_params[:name],
                             product_category_id: product_params[:product_category_id],
                             thumbnail: product_params[:thumbnail],
                             user_id: context.user_id)
      @product.save!
    end

    def create_ingredients!
      ingredients = ingredient_params || []
      ingredients&.each_value do |ing|
        @ingredient = Ingredient.create!(material_id: ing['material_id'],
                                         product_id: @product.id,
                                         user_id: context.user_id)

        create_ingredient_costing!(@ingredient.id, ing['quantity'], ing['cost_per_unit'])
      end
    end

    def create_ingredient_costing!(ingredient_id, quantity, cost_per_unit)
      total_cost = (quantity.to_f * cost_per_unit.to_f).round(3)
      IngredientCosting.create!(ingredient_id: ingredient_id, quantity: quantity.to_f,
                                ingredient_total_cost: total_cost)
    end

    def create_product_costing!
      ProductCosting.create!(product_costing_params.merge(product_id: @product.id))
    end
  end
end
