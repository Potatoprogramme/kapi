# frozen_string_literal: true

module Api
  module Kapi
    class CreateProduct
      include Interactor

      def call
        create_product
      end

      def create_product
        product_params = context.product_params.to_h
        # product_costing_params = context.product_costing_params
        product = Product.new(name: product_params[:name],
                              product_category_id: product_params[:product_category_id],
                              thumbnail: product_params[:thumbnail],
                              user_id: context.user_id)
        if product.save
          context.product = product
        else
          context.fail!(error: product.errors.full_messages.to_sentence)
        end
      end
    end
  end
end
