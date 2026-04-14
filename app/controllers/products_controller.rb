# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit]
  before_action :load_form_data, only: %i[new edit]
  # allow_unauthenticated_access only: %i[index show]
  def index
    @products = Product.active.order(name: :asc)
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    # render json: ingredient_create_params
    result = Products::CreateProduct.call(product_params: product_params,
                                          ingredient_create_params: ingredient_create_params,
                                          product_costing_params: product_costing_params,
                                          user_id: Current.user.id)
    if result.success?
      redirect_to products_path, notice: t('.success')
    else
      # 1. Reload the data needed for the form (dropdowns, etc.)
      load_form_data

      # 2. Add the error from the interactor to the model
      # This makes it show up in your 'error_messages' partial in the view
      @product.errors.add(:base, result.error) if result.error.present?

      # 3. Render the form again with the errors
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: %i[name description thumbnail])
  end

  def ingredient_create_params
    params.expect(product: {
                    ingredients: [{ to_create: [%i[material_id quantity cost_per_unit]] }]
                  })
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
