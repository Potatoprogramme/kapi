# frozen_string_literal: true

class MaterialsController < ApplicationController
  before_action :set_material, only: %i[show edit update destroy]
  allow_unauthenticated_access only: %i[index show]
  def index
    @materials = Material.all
  end

  def show; end

  def new
    @material = Material.new
  end

  def edit; end

  def create
    @material = Material.new(material_params)
    if @material.save
      redirect_to materials_path, notice: t('.success')
    else
      render :new, status: :unprocessable_content, notice: t('.failure')
    end
  end

  def update
    if @material.update(material_params)
      redirect_to material_path(@material), notice: t('.success')
    else
      render :edit, status: :unprocessable_content, notice: t('.failure')
    end
  end

  def destroy
    if Ingredient.exists?(material_id: @material.id)
      redirect_back_or_to(materials_path, notice: t('.exists'))
    else
      @material.destroy
      redirect_to materials_path, notice: t('.success')
    end
  end

  private

  def material_params
    params.expect(material: %i[name quantity cost grams cost_per_unit unit])
  end

  def set_material
    @material = Material.find(params[:id])
  end
end
