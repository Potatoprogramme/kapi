# frozen_string_literal: true

module Api::Kapi::V1
  class MaterialsController < Api::Kapi::V1::ApiController
    before_action :set_material, only: %i[show update destroy]
    before_action :authenticate_user!, except: %i[index show]
    def index
      @materials = Material.order(id: :desc)
    end

    def show; end

    def create
      @material = Material.new(material_params.merge(user_id: current_user.id))
      @material.save!
      render :create, status: :created
    end

    def update
      @material.update!(material_params)
    end

    def destroy
      if Ingredient.exists?(material_id: @material.id)
        render_error(status: :conflict, message: 'Material is currently used in a product')
      else
        @material.destroy
      end
    end

    private

    def material_params
      params.expect(material: %i[name quantity cost cost_per_unit unit])
    end

    def set_material
      @material = Material.find(params[:id])
    end
  end
end
