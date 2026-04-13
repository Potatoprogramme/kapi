# frozen_string_literal: true

module Api::Kapi::V1
  class ProductsController < Api::Kapi::V1::ApiController
    before_action :set_product, only: %i[show]
    before_action :authenticate_user!, except: %i[index show]
    def index
      @products = Product.order(name: :asc)
      render :index, status: :ok
    end

    def show
      render :show, status: :ok
    end

    def create
      result = Api::Kapi::CreateProduct.call(
        product_params: product_params,
        user_id: current_user.id
        # product_costing_params: product_costing_params
      )
      if result.success?
        render :create, status: :created
      else
        render_error(status: :unprocessable_content, message: 'Error saving', errors: result)
      end
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.expect(product: [
                      :name,
                      :product_category_id,
                      :thumbnail,
                      { ingredients: %i[
                        material_id
                        quantity
                        cost_per_unit
                      ] }
                    ])
    end

    def product_costing_params
      params.expect(product: %i[overhead_percentage
                                profit_margin_percentage
                                selling_price
                                direct_cost
                                overhead_cost
                                total_cost
                                profit_margin_amount])
    end
  end
end
