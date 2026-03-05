# frozen_string_literal: true

class MaterialsController < ApplicationController
  before_action :set_material, only: %i[show edit update destroy]
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
      redirect_to materials_path, notice: 'Material created successfully.'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @material.update(material_params)
      redirect_to material_path(@material), notice: 'Material updated successfully.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @material = Material.find(params[:id])
    return unless @material.destroy

    redirect_to materials_path
  end

  private

  def material_params
    params.expect(material: %i[name quantity cost grams cost_per_unit unit])
  end

  def set_material
    @material = Material.find(params[:id])
  end
end
