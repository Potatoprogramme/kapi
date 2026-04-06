# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Materials', type: :request do
  let!(:material) { create(:material) }
  let(:valid_attributes) { attributes_for(:material) }
  let(:invalid_attributes) { attributes_for(:material, name: nil) }

  before do
    user = create(:user)
    post session_path, params: { email_address: user.email_address, password: 'password' }
  end
  describe 'GET /index' do
    it 'assigns all materials to @materials and renders materials index' do
      get materials_path
      expect(response.body).to include(material.name)
      expect(response).to have_http_status(:ok)
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

    context 'when invalid params' do
      it 'does not create a new material and renders the new again' do
        expect do
          post materials_path, params: { material: invalid_attributes }
        end.not_to change(Material, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /edit' do
    it 'it assigns material and renders the edit form' do
      get edit_material_path(material)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(material.name)
      expect(response.body).to include(material.unit)
      expect(response.body).to include(material.quantity.to_s)
      expect(response.body).to include(material.cost.to_s)
    end
  end

  describe 'PATCH /update' do
    context 'when valid params' do
      let(:new_attributes) { { name: 'Updated Bean', cost: 90.00, quantity: 300 } }

      it 'updates the material data an redirects to materials_path' do
        patch material_path(material), params: { material: new_attributes }
        expect(material.reload.name).to eq('Updated Bean')
        expect(response).to redirect_to(material_path(material))
      end
    end

    context 'when invalid params' do
      it 'does not update material and redirects back to edit form' do
        patch material_path(material), params: { material: invalid_attributes }
        expect(material.reload.name).to eq(material.name)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE materials#destroy' do
    it 'deletes the specified material' do
      expect do
        delete material_path(material)
      end.to change(Material, :count).by(-1)
      expect(response).to redirect_to(materials_path)
    end
  end
end
