# frozen_string_literal: true

module Api::Kapi
  class FetchMaterials
    include Interactor

    def call
      context.materials = Material.all
    end
  end
end
