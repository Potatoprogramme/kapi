# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  allow_unauthenticated_access ony: %i[index show]
  def index
    @products = Product.all
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to product_path(@product)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Product was successfully deleted.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: %i[name thumbnail])
  end
end
