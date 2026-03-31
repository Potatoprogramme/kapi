# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    load_data(params[:tab])
  end

  def create
    insert_order
    redirect_to orders_path, notice: t('.success')
  rescue StandardError => e
    load_data
    flash.now[:alert] = e.message
    render :index, status: :unprocessable_content
  end

  def complete
    Order.where(id: params[:id]).update(status: :completed)
    redirect_to orders_path, notice: t('.success')
  end

  def void
    Order.where(id: params[:id]).update(status: :voided)
    redirect_to orders_path, notice: t('.success')
  end

  private

  def order_params
    params.expect(order: %i[
                    order_total
                    payment_method
                  ])
  end

  def order_items_params
    params.expect(order: { order_items_attributes: [%i[product_id quantity]] })
  end

  def insert_order
    order = Order.new(order_params)
    order[:user_id] = Current.user.id
    ActiveRecord::Base.transaction do
      order.save!
      order_items_params[:order_items_attributes].each_value do |item|
        insert_order_item(order.id, item['product_id'], item['quantity'])
      end
    end
  end

  def insert_order_item(order_id, product_id, quantity)
    product = Product.includes(:product_costing).find(product_id)
    item_total_cost = (quantity.to_f * product.product_costing.selling_price.to_f).to_f.round(2)
    OrderItem.create!(order_id: order_id, product_id: product_id, cost_per_item: product.product_costing.selling_price,
                      item_name: product.name, quantity: quantity, item_total_cost: item_total_cost)
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
end
