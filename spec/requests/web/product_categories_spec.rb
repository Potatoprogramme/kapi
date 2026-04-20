# frozen_string_literal: true

require 'rails_helper'
require_relative 'support/shared_context/web_authentication'

RSpec.describe 'ProductCategories', type: :request do
  include_context 'web authenticated request'
  let(:product_category) { create(:product_category) }
  describe 'GET /index' do
    it 'should return a successful response' do
      get product_categories_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /edit' do
    it 'assigns product and renders product form' do
      get edit_product_category_path(product_category.id)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product_category.name)
    end
  end

  describe 'POST /create' do
    context 'when valid params' do
      it 'creates product category and redirects to product cateogry' do
        new_category = build(:product_category)
        expect do
          post product_categories_path, params: { product_category: {
            name: new_category.name,
            description: new_category.description
          } }
        end.to change(ProductCategory, :count).by(1)
        expect(response).to redirect_to(product_categories_path)
      end
    end

    context 'when invalid params' do
      it 'does not create new product category and renders the new again' do
        new_category = build(:product_category)
        expect do
          post product_categories_path, params: { product_category: {
            name: nil,
            description: new_category.description
          } }
        end.not_to change(ProductCategory, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
