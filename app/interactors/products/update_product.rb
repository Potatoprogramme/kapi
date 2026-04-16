# frozen_string_literal: true

module Products
  class UpdateProduct
    include Interactor

    def call
      ActiveRecord::Base.transaction do
        update_product!
        remove_create_update_ing!
        update_product_costing!
      end
      context.product = @product
    rescue ActiveRecord::RecordInvalid => e
      context.product = @product || e.record
      context.fail!(error: e.record.errors.full_messages.to_sentence)
    end

    private

    def product_params
      context.product_params
    end

    def product_costing_params
      context.product_costing_params
    end

    def remove_create_update_ing!
      remove_ingredients!
      create_ingredients!
      update_ingredients!
    end

    def update_product!
      @product = context.product
      @product.update!(product_params)
    end

    def remove_ingredients!
      to_delete = Array(context.ingredient_delete_params).map(&:to_i)
      return if to_delete.empty?

      @product.ingredients.where(id: to_delete).destroy_all
    end

    def create_ingredients!
      to_create = context.ingredient_create_params
      return if to_create.empty?

      to_create.each_value do |ing|
        total_cost = (ing['quantity'].to_f * ing['cost_per_unit'].to_f).round(3)
        Ingredient.create!(material_id: ing['material_id'],
                           product_id: @product.id,
                           user_id: context.user_id,
                           quantity: ing['quantity'],
                           total_cost: total_cost)
      end
    end

    def update_ingredients!
      to_update = context.ingredient_update_params
      return if to_update.empty?

      to_update.each_value do |ing|
        total_cost = ing['quantity'].to_f * ing['cost_per_unit'].to_f
        Ingredient.where(id: ing['ingredient_id']).update!(
          material_id: ing['material_id'],
          quantity: ing['quantity'],
          total_cost: total_cost
        )
      end
    end

    def update_product_costing!
      product_costing = ProductCosting.find_by(product_id: @product.id)
      product_costing.presence&.update!(product_costing_params)
    end
  end
end
