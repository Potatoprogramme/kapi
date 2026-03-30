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
  end
end
