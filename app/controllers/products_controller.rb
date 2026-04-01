# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update soft_delete]
  allow_unauthenticated_access only: %i[index show]
  def index
    load_products
  end

  def show
    @product = Product.left_joins(:product_costing, :product_category, :user)
                      .where(id: @product.id)
                      .select('products.*, product_costings.*,
                      product_categories.name as category_name,
                      product_categories.description, users.email_address')
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
    create_product
    redirect_to products_path, notice: t('.success')
  rescue StandardError => e
    load_form_data
    @product.errors.add(:ingredients, 'cannot be empty') unless params[:product].key?('ingredients')
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_content
  end

  def update
    update_product
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

  def load_products
    @products = Product.active.left_joins(:product_costing,
                                          :product_category)
                       .select('products.*, product_costings.selling_price, product_categories.name as category_name')
                       .order(id: :asc)
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
    params.expect(product: { ingredients: [%i[material_id quantity cost_per_unit]] })
  end

  def product_costing_params
    params.expect(product: %i[overhead_percentage profit_margin_percentage direct_cost overhead_cost
                              total_cost profit_margin_amount selling_price])
  end

  def create_product
    @product = Product.new(product_params)
    @product.user_id = Current.user.id
    ActiveRecord::Base.transaction do
      @product.save!
      create_ingredients
      create_product_costing(@product.id)
    end
  end

  def create_ingredients
    ingredient_params[:ingredients].each_value do |ingredient|
      new = Ingredient.create!(product_id: @product.id, material_id: ingredient['material_id'],
                               user_id: Current.user.id)
      create_ingredient_costing(new.id, ingredient['quantity'], ingredient['cost_per_unit'])
    end
  end

  def update_product
    ActiveRecord::Base.transaction do
      @product.update(product_params)
      update_ingredient
      update_product_costing(@product.id)
    end
    redirect_to products_path, notice: t('.success')
  rescue StandardError => e
    load_form_data(@product.id)
    @product.errors.add(:ingredients, 'cannot be empty') unless params[:product].key?('ingredients')
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_content
  end

  def update_ingredient
    existing_map = load_existing_ingredients
    submitted_ids = extract_submitted_material_ids

    remove_unsubmitted_ingredients(existing_map, submitted_ids)
    sync_submitted_ingredients(existing_map)
  end

  def load_existing_ingredients
    Ingredient.where(product_id: @product.id)
              .includes(:ingredient_costing)
              .index_by(&:material_id)
  end

  def extract_submitted_material_ids
    ingredient_params[:ingredients].values.map { |m| m['material_id'].to_i }
  end

  def remove_unsubmitted_ingredients(existing_map, submitted_ids)
    # Calculate which ingredients need to be deleted:
    # Subtract submitted material IDs from existing ones to find removed ingredients
    (existing_map.keys - submitted_ids).each do |material_id|
      # Delete each ingredient that was removed from the form
      existing_map[material_id]&.destroy
    end
  end

  def sync_submitted_ingredients(existing_map)
    ingredient_params[:ingredients].each_value do |ingredient_data|
      material_id = ingredient_data['material_id'].to_i
      quantity = ingredient_data['quantity'].to_f
      cost_per_unit = ingredient_data['cost_per_unit'].to_f

      if existing_map[material_id] # if null skips and create new ingredient with the material id
        update_ingredient_costing(existing_map[material_id], quantity, cost_per_unit)
      else
        create_new_ingredient_with_costing(material_id, quantity, cost_per_unit)
      end
    end
  end

  def update_ingredient_costing(ingredient, quantity, cost_per_unit)
    costing = ingredient.ingredient_costing
    return unless costing && costing.quantity.to_f != quantity

    total_cost = (quantity * cost_per_unit).round(3)
    costing.update(quantity: quantity, ingredient_total_cost: total_cost)
  end

  def create_new_ingredient_with_costing(material_id, quantity, cost_per_unit)
    ingredient = Ingredient.create!(
      product_id: @product.id,
      material_id: material_id,
      user_id: Current.user.id
    )
    create_ingredient_costing(ingredient.id, quantity, cost_per_unit)
  end

  def create_ingredient_costing(ingredient_id, quantity, cost_per_unit)
    ingredient_total_cost = (quantity.to_f * cost_per_unit.to_f).round(3)
    IngredientCosting.create!(ingredient_id: ingredient_id, quantity: quantity,
                              ingredient_total_cost: ingredient_total_cost)
  end

  def create_product_costing(product_id)
    product_costing = ProductCosting.new(product_costing_params.merge(product_id: product_id))
    product_costing.save!
  end

  def update_product_costing(product_id)
    product_costing = ProductCosting.find_by(product_id: product_id)
    product_costing.presence&.update(product_costing_params)
  end
end
