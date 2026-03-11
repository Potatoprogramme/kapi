# frozen_string_literal: true

class ProductCategoriesController < ApplicationController
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
    end
  end

  private

  def set_product_category
    @category = ProductCategorhy.find(params[:id])
  end

  def product_category_params
    params.expect(category: %i[category_name description color])
  end
end
