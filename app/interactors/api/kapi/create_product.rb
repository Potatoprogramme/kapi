# frozen_string_literal: true

module Api
  module Kapi
    class CreateProduct
      include Interactor

      def call
        product_params = context.product_params.to_h
        ActiveRecord::Base.transaction do
          create_product(product_params)
          create_ingredients(product_params)
        end
      rescue ActiveRecord::RecordInvalid => e
        context.fail!(error: e.record.errors.full_messages.to_sentence)
      end

      def create_product(product_params)
        @product = Product.new(name: product_params[:name],
                               product_category_id: product_params[:product_category_id],
                               thumbnail: product_params[:thumbnail],
                               user_id: context.user_id)
        @product.save!
      end

      def create_ingredients(product_params)
        ingredients = product_params[:ingredients] || []
        ingredients&.each_value do |ing|
          @ingredient = Ingredient.create!(material_id: ing['material_id'], product_id: @product.id,
                                           user_id: context.user_id)
        end
      end
    end
  end
end
