# frozen_string_literal: true

module Orders
  class CreateOrder
    include Interactor

    def call
      ActiveRecord::Base.transaction do
        create_order!
      end
      context.order = @order
    rescue ActiveRecord::RecordInvalid => e
      context.order = @order || e.record
      context.fail!(errors: e.record.errors.full_messages.to_sentence)
    end

    private

    def order_params
      context.order_params
    end

    def order_items_params
      context.order_items_params
    end

    def create_order!
      @order = Order.create!(order_params.merge(user_id: context.user_id))
      order_items_params[:order_items_attributes].each_value do |item|
        create_order_items!(@order.id, item['product_id'], item['quantity'])
      end
    end

    def create_order_items!(order_id, product_id, quantity)
      product = Product.find(product_id)
      item_total_cost = (quantity.to_f * product.product_costing.selling_price.to_f).to_f.round(2)
      OrderItem.create!(order_id: order_id, product_id: product_id,
                        cost_per_item: product.product_costing.selling_price,
                        item_name: product.name, quantity: quantity, item_total_cost: item_total_cost)
    end
  end
end
