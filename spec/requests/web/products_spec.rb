# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProductsController', type: :request do
  render_views

  let!(:user) { create(:user) }
  let!(:product_category) { create(:product_category, user: user) }
  let!(:product) { create(:product, :with_ingredients, :with_costing, user: user, product_category: product_category) }
  let!(:material_one) { create(:material) }
  let!(:material_two) { create(:material) }
  let!(:session_record) { user.sessions.create!(user_agent: 'RSpec', ip_address: '127.0.0.1') }

  let(:thumbnail) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/thumbnail.jpg'),
      'image/jpeg'
    )
  end

  let(:create_params) do
    {
      product: {
        name: 'Chocolate Velvet',
        product_category_id: product_category.id,
        description: 'Sample product description',
        thumbnail: thumbnail,
        ingredients: {
          to_create: {
            '0' => {
              material_id: material_one.id,
              quantity: '10',
              cost_per_unit: material_one.cost_per_unit.to_s
            },
            '1' => {
              material_id: material_two.id,
              quantity: '20',
              cost_per_unit: material_two.cost_per_unit.to_s
            }
          }
        },
        overhead_percentage: '20',
        profit_margin_percentage: '20',
        selling_price: '200',
        direct_cost: '114.27',
        overhead_cost: '22.85',
        total_cost: '137.13',
        profit_margin_amount: '34.28'
      }
    }
  end

  let(:update_params) do
    {
      product: {
        name: 'Updated Chocolate Velvet',
        product_category_id: product_category.id,
        description: 'Updated description',
        thumbnail: thumbnail,
        overhead_percentage: '20',
        profit_margin_percentage: '20',
        selling_price: '220',
        direct_cost: '114.27',
        overhead_cost: '22.85',
        total_cost: '137.13',
        profit_margin_amount: '34.28'
      }
    }
  end

  before do
    cookies.signed[:session_id] = session_record.id
  end

  describe 'GET #index' do
    it 'renders the products index' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end
  end

  describe 'GET #show' do
    it 'renders the product show page' do
      get :show, params: { id: product.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end
  end

  describe 'GET #new' do
    it 'renders the new product form' do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'creates a product with ingredients and costing' do
      expect do
        post :create, params: create_params
      end.to change(Product, :count).by(1)
                                    .and change(Ingredient, :count).by(2)
                                                                   .and change(ProductCosting, :count).by(1)

      expect(response).to redirect_to(products_path)
    end
  end

  describe 'GET #edit' do
    it 'renders the edit form' do
      get :edit, params: { id: product.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end
  end

  describe 'PATCH #update' do
    it 'updates the product and redirects back to edit' do
      patch :update, params: { id: product.id }.merge(update_params)

      expect(product.reload.name).to eq('Updated Chocolate Velvet')
      expect(response).to redirect_to(edit_product_path(product))
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the product' do
      expect do
        delete :destroy, params: { id: product.id }
      end.to change(Product, :count).by(-1)

      expect(response).to redirect_to(products_path)
    end
  end
end
