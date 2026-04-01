# frozen_string_literal: true

module Api::Kapi::V1
  class MaterialsController < Api::Kapi::V1::ApiController
    before_action :set_material, only: %i[update destroy]
    def index
      result = Api::Kapi::FetchMaterials.call
      if result.success?
        render :index, locals: { materials: result.materials }
      else
        render_error(status: :unprocessable_entity, message: result.error)
      end
    end

    def create
      @material = Material.new(material_params.merge(user_id: current_user.id))
      if @material.save
        render :create, locals: { material: @material }, status: :created
      else
        render_error(status: :unprocessable_content, message: 'Failed to create material',
                     errors: @material.errors.to_hash)
      end
    end

    def update
      if @material.update(material_params)
        render :update, locals: { material: @material }, status: :ok
      else
        render_unprocessable_content(@material.errors)
      end
    end

    def destroy
      if Ingredient.exists?(material_id: @material.id)
        render_error(status: :unprocessable_content, message: 'Material is currently used')
      else
        @material.destroy
        render :destroy, status: :ok
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
