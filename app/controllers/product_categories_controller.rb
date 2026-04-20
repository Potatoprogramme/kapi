# frozen_string_literal: true

class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: %i[edit update destroy]
  def index
    @categories = ProductCategory.all
  end

  def new
    @category = ProductCategory.new
  end

  def edit; end

  def create
    @category = ProductCategory.new(product_category_params.merge(user_id: Current.user.id))
    if @category.save
      redirect_to product_categories_path, notice: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @category.update(product_category_params)
    redirect_to product_category_path(@category), notice: t('.success')
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
    params.expect(product_category: %i[name description])
  end
end
