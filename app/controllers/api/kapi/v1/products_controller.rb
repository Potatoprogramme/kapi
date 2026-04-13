# frozen_string_literal: true

module Api::Kapi::V1
  class ProductsController < Api::Kapi::V1::ApiController
    before_action :set_product, only: %i[show]
    def index
      @products = Product.order(name: :asc)
      render :index, status: :ok
    end

    def show
      render :show, status: :ok
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end
  end
end
