# frozen_string_literal: true

module Api::Kapi::V1
  class ProductCategoriesController < Api::Kapi::V1::ApiController
    def index
      @categories = ProductCategory.order(id: :desc)
      render :index, status: :ok
    end
  end
end
