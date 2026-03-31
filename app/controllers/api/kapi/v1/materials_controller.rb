# frozen_string_literal: true

module Api::Kapi::V1
  class MaterialsController < Api::Kapi::V1::ApiController
    def index
      result = Api::Kapi::FetchMaterials.call
      if result.success?
        render :index, locals: { materials: result.materials }
      else
        render json: { error: 'Failed to fetch materials' }, status: :unprocessable_content
      end
    end

    def create
      material = Material.new(name: material_params[:name], quantity: material_params[:quantity],
                              cost: material_params[:cost], cost_per_unit: material_params[:cost_per_unit],
                              unit: material_params[:unit],
                              user_id: Current.user.id)
      if material.save
        render json: material, status: :created
      else
        render json: { error: 'Failed to create material' }, status: :unprocessable_content
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
