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
    load_form_data
  end

  def edit
    load_form_data
  end

  def create
    @product = Product.new(product_params)
    ActiveRecord::Base.transaction do
      @product.save!
      ingredient_ids.each do |material_id|
        Ingredient.create!(product_id: @product.id, material_id: material_id)
      end
    rescue ActiveRecord::RecordInvalid => e
      load_form_data
      e.record.error.full_message.to_sentence
      render :new, status: :unprocessable_content, notice: t('.success')
    end
    redirect_to products_path, notice: t('.success')
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

  def ingredient_ids
    params.expect(myIngredients: [])
  end
end
