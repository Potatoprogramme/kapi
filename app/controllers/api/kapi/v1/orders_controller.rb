# frozen_string_literal: true

module Api::Kapi::V1
  class OrdersController < Api::Kapi::V1::ApiController
    before_action :set_order, only: %i[complete void hard_delete]
    before_action :authenticate_user!, except: %i[index]

    def index
      load_data(params[:tab])
    end

    def create
      result = Orders::CreateOrder.call(order_params: order_params,
                                        order_items_params: order_items_params,
                                        user_id: current_user.id)
      return unless result.success?

      @order = result.order
      render :create, status: :created
    end

    def hard_delete
      @order.destroy!
    end

    def complete
      @order.completed!
    end

    def void
      @order.voided!
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def load_data(tab = 'pending')
      # For Product Options
      @products = Product.active.left_joins(:product_costing,
                                            :product_category)
                         .select('products.*, product_costings.selling_price,
                       product_categories.name as category_name, product_categories.id as category_id')
      # For Listing Orders
      status = Order.statuses.keys.include?(tab) ? tab : 'pending'
      @orders = Order.where(status: status).order(id: :desc)
    end

    def order_params
      params.expect(order: %i[
                      order_total
                      payment_method
                    ])
    end

    def order_items_params
      params.expect(order: { order_items_attributes: [%i[product_id quantity]] })
    end
  end
end
