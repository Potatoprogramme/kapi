# frozen_string_literal: true

module Api::Kapi::V1
  class ProductCategoriesController < Api::Kapi::V1::ApiController
    before_action :set_product, only: %i[show update destroy]
    before_action :authenticate_user!, except: %i[index show]
    def index
      @categories = ProductCategory.order(id: :desc)
    end

    def show; end

    def create
      @category = ProductCategory.new(category_params.merge(user_id: current_user.id))
      @category.save!
      render :create, status: :created
    end

    def update
      @category.update!(category_params)
    end

    def destroy
      @category.destroy!
    end

    private

    def set_product
      @category = ProductCategory.find(params[:id])
    end

    def category_params
      params.expect(category: %i[name description])
    end
  end
end
