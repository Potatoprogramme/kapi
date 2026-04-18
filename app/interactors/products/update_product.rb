# frozen_string_literal: true

module Products
  class UpdateProduct
    include Interactor

    delegate :product,
             :product_params,
             :product_costing_params,
             :ingredient_create_params,
             :ingredient_delete_params,
             :ingredient_update_params,
             :user_id,
             to: :context

    def call
      ActiveRecord::Base.transaction do
        update_product!
        remove_create_update_ing!
        update_product_costing!
      end
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(errors: e.record.errors)
    end

    private

    def remove_create_update_ing!
      remove_ingredients!
      create_ingredients!
      update_ingredients!
    end

    def update_product!
      product.update!(product_params)
    end

    def remove_ingredients!
      to_delete = Array(ingredient_delete_params).map(&:to_i)
      return if to_delete.empty?

      product.ingredients.where(id: to_delete).destroy_all
    end

    def create_ingredients!
      to_create = ingredient_create_params
      return if to_create.empty?

      to_create.each_value do |ing|
        total_cost = (ing['quantity'].to_f * ing['cost_per_unit'].to_f).round(3)
        Ingredient.create!(material_id: ing['material_id'],
                           product_id: product.id,
                           user_id: user_id,
                           quantity: ing['quantity'],
                           total_cost: total_cost)
      end
    end

    def update_ingredients!
      to_update = ingredient_update_params
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
      product_costing = ProductCosting.find_by(product_id: product.id)
      return if product_costing.blank?

      product_costing.update!(product_costing_params)
    end
  end
end
