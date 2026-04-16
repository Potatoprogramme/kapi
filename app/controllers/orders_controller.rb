# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :load_data, only: %i[create]
  def index
    load_data(params[:tab])
  end

  def create
    result = Orders::CreateOrder.call(order_params: order_params,
                                      order_items_params: order_items_params,
                                      user_id: Current.user.id)
    if result.success?
      redirect_to orders_path, notice: t('.success')
    else
      load_data
      render :index, status: :unprocessable_content
    end
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
