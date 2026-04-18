# frozen_string_literal: true

module Api::Kapi::V1
  class OrdersController < Api::Kapi::V1::ApiController
    before_action :set_order, only: %i[complete void hard_delete]
    before_action :authenticate_user!, except: %i[index]

    def index
      fetch_orders(params[:filter])
    end

    def create
      result = Orders::CreateOrder.call(order_params: order_params,
                                        order_items_params: order_items_params,
                                        user_id: current_user.id)
      if result.success?
        @order = result.order
        render :create, status: :created
      else
        render_error(status: :unprocessable_content, message: 'Order created successfully', errors: result.errors)
      end
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

    def fetch_orders(filter = 'pending')
      filter = 'pending' unless Order.statuses.keys.include?(filter)

      @orders = Order.where(status: filter)
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
