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
    load_form_data(@product.id)
  end

  def create
    insert_product
    redirect_to products_path, notice: t('.success')
  rescue StandardError => e
    load_form_data
    @product.errors.add(:ingredients, 'cannot be empty') unless params[:product].key?(:ingredients)
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_content
  end

  def insert_product
    @product = Product.new(product_params)
    ActiveRecord::Base.transaction do
      @product.save!
      insert_ingredient('create')
    end
  end

  def insert_ingredient(method = nil)
    if method == 'update'
      Ingredient.where(product_id: @product.id).destroy
    elsif method == 'create'
      ingredient_params.each do |material|
        Ingredient.create!(product_id: @product.id, material_id: material['id'])
      end
    end
  end

  def update
    update_product
    redirect_to products_path, notice: t('.success')
  rescue StandardError => e
    @product.errors.add(:ingredients, 'cannot be empty')
    flash.now[:alert] = e.message
    load_form_data(@product.id)
    render json: params, status: :unprocessable_content
  end

  def update_product
    ActiveRecord::Base.transaction do
      @product.update(product_params)
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
    params.expect(product: %i[name thumbnail product_category_id])
  end

  def load_form_data(product_id = nil)
    @materials = Material.all
    @categories = ProductCategory.all
    @ingredients = Ingredient.left_joins(:material)
                             .where(product_id: product_id).select('ingredients.*, materials.*')
  end

  def ingredient_params
    params[:product][:ingredients]&.values || []
  end
end
