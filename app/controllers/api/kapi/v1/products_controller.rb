# frozen_string_literal: true

module Api::Kapi::V1
  class ProductsController < Api::Kapi::V1::ApiController
    def index
      @products = Product.order(name: :asc)
      render :index, status: :ok
    end
  end
end
