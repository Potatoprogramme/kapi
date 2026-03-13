# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  allow_unauthenticated_access only: %i[index show]
  def index
    @products = Product.all
  end

  def show; end

  def new
    @product = Product.new
    load_form_data
  end

  def edit
    load_form_data
    fetch_ingredients(@product.id)
  end

  def create
    insert_product
    redirect_to products_path, notice: t('.success')
  rescue StandardError => e
    load_form_data
    Rails.logger.error(e.message)
    flash.now[:alert] = t('.failure')
    render :new, status: :unprocessable_content
  end

  def insert_product
    @product = Product.new(product_params)
    ActiveRecord::Base.transaction do
      @product.save!
      ingredient_ids.each do |material_id|
        Ingredient.create!(product_id: @product.id, material_id: material_id)
      end
    end
  end

  def update
    update_product
  rescue StandardError => e
    Rails.logger.error(e.message)
    flash.now[:alert] = e.message
    load_form_data
    render :new, status: :unprocessable_content
  end

  def update_product
    AcitveRecord::Base.transaction do
      @product.update(product_params)
      Ingredient.where(product_id: @product.id).delete_all
      ingredient_ids.each do |material_id|
        Ingredient.create!(product_id: @product.id, material_id: material_id)
      end
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: t('.success')
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: %i[name thumbnail myIngredients product_category_id])
  end

  def load_form_data
    @materials = Material.all
    @categories = ProductCategory.all
  end

  def fetch_ingredients(product_id)
    @ingredients = Ingredient.joins(:material).where(product_id: product_id)
  end

  def ingredient_ids
    params.expect(myIngredients: [])
  end
end
