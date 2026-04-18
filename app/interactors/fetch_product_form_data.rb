# frozen_string_literal: true

class FetchProductFormData
  include Interactor

  def call
    context.materials = Material.all
    context.categories = ProductCategory.all
  end
end
