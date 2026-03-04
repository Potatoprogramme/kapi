# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Materials', type: :request do
  let!(:material) { create(:material) }
  let(:valid_attributes) { attributes_for(:material) }
  let(:invalid_attributes) { attributes_for(:material, name: nil) }
  describe 'GET /index' do
    it 'renders materials index' do
      get materials_path
      expect(response).to have_http_status(:ok)
    end

    it 'assigns all materials to @materials' do
      get materials_path
      expect(response.body).to include(material.name)
    end
  end

  describe 'GET /show' do
    it 'renders #show and returns success' do
      get material_path(material)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /create' do
    context 'when valid params' do
      it 'creates material and redirects to material index' do
        expect do
          post materials_path, params: { material: valid_attributes }
        end.to change(Material, :count).by(1)
        expect(response).to redirect_to(materials_path)
      end
    end
  end
end
