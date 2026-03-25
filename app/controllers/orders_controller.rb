# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @products = Product.active.left_joins(:product_costing,
                                          :product_category)
                       .select('products.*, product_costings.selling_price,
                       product_categories.name as category_name, product_categories.id as category_id')
    @order = Order.all
  end

  def create
    render json: { params: params, order: order_params, order_items_params: order_items_params }
    # insert_order
    # redirect_to orders_path, notice: t('.success')
  end

  private

  def order_params
    params.expect(order: [
                    :order_total,
                    :payment_method,
                    { order_items_attributes: [%i[quantity product_id]] }
                  ])
  end

  def order_items_params
    params[:order][:order_items_attributes]&.values
  end

  def insert_order
    order = Order.new(order_params)
    order[:user_id] = Current.user.id
    ActiveRecord::Base.transaction do
      order.save!
      order_item_params
    end
  end

  def insert_order_item(order_id, product_id)
    Order.create!(order_id: order_id, product_id: product_id,
                  item_name: item_name, quantity: quantity, item_total_cost: item_total_cost)
  end
end
