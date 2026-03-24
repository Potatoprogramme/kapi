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
    insert_order
  end

  private

  def order_params
    params.expect(order: %i[order_total payment_method])
  end

  def order_items_params
    params[:order][:order_items_attributes]&.values
  end

  def insert_order
    order = Order.new(order_params)
    ActiveRecord::Base.transaction do
      order.save!
    end
  end
end
