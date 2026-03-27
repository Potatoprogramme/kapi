# frozen_string_literal: true

module API
  module KAPI
    module V1
      class MaterialsController < APIController
        def index
          @materials = Material.all
          render json: @materials
        end
      end
    end
  end
end
