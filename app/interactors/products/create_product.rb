# frozen_string_literal: true

module Products
  class CreateProduct
    include Interactor

    delegate :product,
             :product_params,
             :ingredient_create_params,
             :product_costing_params,
             :user_id,
             to: :context

    before { validate_ingredients! }

    def call
      ActiveRecord::Base.transaction do
        self.product = create_product!
        create_ingredients!
        create_product_costing!
      end
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(errors: e.record.errors)
    end

    private

    def create_product!
      Product.create!(product_params.merge(user_id: user_id))
    end

    def create_ingredients!
      ingredient_create_params&.each_value do |ing|
        total_cost = (ing['quantity'].to_f * ing['cost_per_unit'].to_f).round(3)
        Ingredient.create!(
          material_id: ing['material_id'],
          product_id: product.id,
          user_id: user_id,
          quantity: ing['quantity'].to_f,
          total_cost: total_cost
        )
      end
    end

    def create_product_costing!
      ProductCosting.create!(product_costing_params.merge(product_id: product.id))
    end

    def validate_ingredients!
      return if ingredient_create_params.present?

      self.product = Product.new(product_params)
      product.errors.add(:ingredients, "can't be blank")
      context.fail!(errors: product.errors.full_messages.to_sentence)
    end
  end
end
