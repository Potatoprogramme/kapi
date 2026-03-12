# frozen_string_literal: true

class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: %i[destroy]
  def index
    @categories = ProductCategory.all
  end

  def new
    @category = ProductCategory.new
  end

  def create
    @category = ProductCategory.new(product_category_params)
    if @category.save
      redirect_to product_categories_path, notice: t('.success')
    else
      render :new, unprocessable_content, notice: t('.failure')
    end
  end

  def destroy
    @category.destroy
    redirect_to product_categories_path, notice: t('.success')
  end

  private

  def set_product_category
    @category = ProductCategory.find(params[:id])
  end

  def product_category_params
    params.expect(product_category: %i[name description color])
  end
end
