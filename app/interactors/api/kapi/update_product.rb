# frozen_string_literal: true

module Api
  module Kapi
    class UpdateProduct
      include Interactor

      def call
        @ingredient_params = context.ingredient_params.to_h
        ActiveRecord::Base.transaction do
          update_product
        end
      end

      private
      def to_delete
        @ingredient_params
      end

      def to_update
        
      end

      def to_delete
        
      end
      def update_product
        
      end
    end
  end
end
