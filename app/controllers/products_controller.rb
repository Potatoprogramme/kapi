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
  rescue ActiveRecord::RecordInvalid => e
    load_form_data
    @product.errors.add(:ingredients, 'cannot be empty') unless params[:product].key?('ingredients')
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_content
  end

  def update
    update_product
    redirect_to products_path, notice: t('.success')
  rescue StandardError => e
    load_form_data(@product.id)
    @product.errors.add(:ingredients, 'cannot be empty') unless params[:product].key?('ingredients')
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_content
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

  def ingredient_params
    params[:product][:ingredients]&.values
  end

  def product_costing_params
    params.expect(product: %i[overhead_percentage profit_margin_percentage direct_cost overhead_cost
                              total_cost profit_margin_amount selling_price])
  end

  def load_form_data(product_id = nil)
    @materials = Material.all
    @categories = ProductCategory.all
    @ingredients = Ingredient.left_joins(:ingredient_costing).left_joins(:material)
                             .where(product_id: product_id)
                             .select('ingredients.*, materials.*, ingredient_costings.quantity,
                             ingredient_costings.ingredient_total_cost')
    @product_costing = ProductCosting.find_by(product_id: product_id)
  end

  def insert_product
    @product = Product.new(product_params)
    ActiveRecord::Base.transaction do
      @product.save!
      insert_ingredient
      insert_product_costing(@product.id)
    end
  end

  def update_product
    ActiveRecord::Base.transaction do
      @product.update(product_params)
      insert_ingredient('update')
      update_product_costing(@product.id)
    end
  end

  def insert_ingredient(method = nil)
    Ingredient.where(product_id: @product.id).destroy_all if method == 'update'
    ingredient_params.each do |material|
      new = Ingredient.create!(product_id: @product.id, material_id: material['id'])
      insert_ingredient_costing(new.id, material['quantity'], material['cost_per_unit'])
    end
  end

  def insert_ingredient_costing(ingredient_id, quantity, cost_per_unit)
    ingredient_total_cost = (quantity.to_f * cost_per_unit.to_f).round(3)
    IngredientCosting.create!(ingredient_id: ingredient_id, quantity: quantity,
                              ingredient_total_cost: ingredient_total_cost)
  end

  def insert_product_costing(product_id)
    product_costing = ProductCosting.new(product_costing_params.merge(product_id: product_id))
    return unless validate_product_costing(product_costing)

    product_costing.save!
  end

  def update_product_costing(product_id)
    product_costing = ProductCosting.find_by(product_id: product_id)
    product_costing.presence&.update(product_costing_params)
  end
end
