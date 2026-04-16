# frozen_string_literal: true

module Products
  class CreateProduct
    include Interactor

    def call
      validate_ingredients!
      ActiveRecord::Base.transaction do
        create_product!
        create_ingredients!
        create_product_costing!
      end
      context.product = @product
    rescue ActiveRecord::RecordInvalid => e
      context.product = @product || e.record
      context.fail!(errors: e.record.errors.full_messages.to_sentence)
    end

    private

    def product_params
      context.product_params
    end

    def to_create_ingredients
      context.ingredient_create_params
    end

    def product_costing_params
      context.product_costing_params
    end

    def create_product!
      @product = Product.create!(product_params.merge(user_id: context.user_id))
    end

    def create_ingredients!
      to_create_ingredients&.each_value do |ing|
        total_cost = (ing['quantity'].to_f * ing['cost_per_unit'].to_f).round(3)
        @ingredient = Ingredient.create!(
          material_id: ing['material_id'],
          product_id: @product.id,
          user_id: context.user_id,
          quantity: ing['quantity'].to_f,
          total_cost: total_cost
        )
      end
    end

    def create_product_costing!
      ProductCosting.create!(product_costing_params.merge(product_id: @product.id))
    end

    def validate_ingredients!
      return if context.ingredient_create_params.present?

      @product = Product.new(product_params)
      @product.errors.add(:ingredients, "can't be blank")
      context.product = @product
      context.fail!(errors: @product.errors.full_messages.to_sentence)
    end
  end
end
