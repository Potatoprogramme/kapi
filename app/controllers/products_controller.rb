# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update soft_delete]
  allow_unauthenticated_access only: %i[index show]
  def index
    load_products
  end

  def show
    @product = Product.left_joins(:product_costing, :product_category)
                      .where(id: @product.id)
                      .select('products.*, product_costings.*,
                      product_categories.name as category_name, product_categories.description')
                      .first
    @ingredients = Ingredient.where(product_id: @product.product_id)
                             .left_joins(:material, :ingredient_costing).select('*')
  end

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

  def soft_delete
    if @product.update(status: :deleted)
      redirect_to products_path, notice: t('.success')
    else
      load_products
      flash.now[:alert] = t('.failure')
      render :index, status: :unprocessable_content
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: %i[
                    name
                    thumbnail
                    product_category_id
                  ])
  end

  def ingredient_params
    params.expect(product: { ingredients: [%i[id quantity cost_per_unit]] })
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
    @product.user_id = Current.user.id
    ActiveRecord::Base.transaction do
      @product.save!
      insert_ingredients
      insert_product_costing(@product.id)
    end
  end

  def update_product
    ActiveRecord::Base.transaction do
      @product.update(product_params)
      update_ingredient
      update_product_costing(@product.id)
    end
  end

  def insert_ingredients
    ingredient_params[:ingredients].each_value do |material|
      new = Ingredient.create!(product_id: @product.id, material_id: material['id'], user_id: Current.user.id)
      insert_ingredient_costing(new.id, material['quantity'], material['cost_per_unit'])
    end
  end

  def update_ingredient
    # Get all existing ingredients for this product
    existing = Ingredient.where(product_id: @product.id).includes(:ingredient_costing)
    existing_map = existing.index_by(&:material_id)

    # Get the submitted ingredient IDs as integers
    param_ingredients = ingredient_params[:ingredients] || {}
    param_ids = param_ingredients.values.map { |m| m['id'].to_i }

    # Remove ingredients not in params
    (existing_map.keys - param_ids).each do |material_id|
      ing = existing_map[material_id]
      ing&.destroy
    end

    # Add or update ingredients
    param_ingredients.each_value do |material|
      mat_id = material['id'].to_i
      qty = material['quantity'].to_f
      cost_per_unit = material['cost_per_unit'].to_f

      if existing_map[mat_id]
        # Update quantity if changed
        costing = existing_map[mat_id].ingredient_costing
        if costing && costing.quantity.to_f != qty
          costing.update(quantity: qty, ingredient_total_cost: qty * cost_per_unit)
        end
      else
        # Add new ingredient
        new_ing = Ingredient.create!(product_id: @product.id, material_id: mat_id, user_id: Current.user.id)
        insert_ingredient_costing(new_ing.id, qty, cost_per_unit)
      end
    end
  end

  def insert_ingredient_costing(ingredient_id, quantity, cost_per_unit)
    ingredient_total_cost = (quantity.to_f * cost_per_unit.to_f).round(3)
    IngredientCosting.create!(ingredient_id: ingredient_id, quantity: quantity,
                              ingredient_total_cost: ingredient_total_cost)
  end

  def insert_product_costing(product_id)
    product_costing = ProductCosting.new(product_costing_params.merge(product_id: product_id))
    product_costing.save!
  end

  def update_product_costing(product_id)
    product_costing = ProductCosting.find_by(product_id: product_id)
    product_costing.presence&.update(product_costing_params)
  end

  def load_products
    @products = Product.active.left_joins(:product_costing,
                                          :product_category)
                       .select('products.*, product_costings.selling_price, product_categories.name as category_name')
  end
end
