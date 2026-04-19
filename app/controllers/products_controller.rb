# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :load_form_data, only: %i[new create edit update]
  allow_unauthenticated_access only: %i[index show]
  def index
    @query = ProductsQuery.new(params)
    @products = @query.call

    # These are used by the view for the search form and pagination
    initialize_search_options
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    result = Products::CreateProduct.call(product_params: product_params,
                                          ingredient_create_params: ingredient_create_params,
                                          product_costing_params: product_costing_params,
                                          user_id: Current.user.id)
    if result.success?
      redirect_to products_path, notice: t('.success')
    else
      @product = result.product
      render :new, status: :unprocessable_content
    end
  end

  def update
    result = Products::UpdateProduct.call(product: @product,
                                          product_params: product_params,
                                          ingredient_create_params: ingredient_create_params,
                                          ingredient_delete_params: ingredient_delete_params,
                                          ingredient_update_params: ingredient_update_params,
                                          product_costing_params: product_costing_params,
                                          user_id: Current.user.id)
    if result.success?
      redirect_to edit_product_path(@product), notice: t('.success')
    else
      @product = result.product
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @product.update!(status: :deleted)
    redirect_to products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: %i[name product_category_id description thumbnail])
  end

  def ingredient_create_params
    params.dig(:product, :ingredients, :to_create) || []
  end

  def ingredient_delete_params
    params.dig(:product, :ingredients, :to_delete) || []
  end

  def ingredient_update_params
    params.dig(:product, :ingredients, :to_update) || []
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

  def load_form_data
    result = FetchProductFormData.call
    @materials = result.materials
    @categories = result.categories
  end
end
