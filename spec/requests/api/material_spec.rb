# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Kapi::V1::Materials', type: :request do
  let(:user) { create(:user) }
  let!(:material) { create(:material, user: user) }
  let(:api_base) { '/api/kapi/v1/materials' }
  let(:valid_attributes) do
    {
      name: 'Arabica Beans',
      quantity: 10,
      cost: 250.0,
      cost_per_unit: 25.0,
      unit: 'grams'
    }
  end
  let(:invalid_attributes) { valid_attributes.merge(name: nil) }

  def json
    JSON.parse(response.parsed_body)
  end

  def auth_headers
    post '/api/kapi/v1/auth/login', params: {
      user: {
        email_address: user.email_address,
        password: 'password'
      }
    }, as: :json

    token = json['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/kapi/v1/materials' do
    it 'returns materials without auth' do
      get api_base, as: :json

      expect(response).to have_http_status(:ok)
      expect(json['materials']).to be_an(Array)
      expect(json['total']).to eq(Material.count)
    end
  end

  describe 'GET /api/kapi/v1/materials/:id' do
    it 'returns a material without auth' do
      get "#{api_base}/#{material.id}", as: :json

      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(material.id)
    end
  end

  describe 'POST /api/kapi/v1/materials' do
    context 'when unauthorized' do
      it 'returns 401' do
        post api_base, params: { material: valid_attributes }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized and params are valid' do
      it 'creates a material' do
        expect do
          post api_base, params: { material: valid_attributes }, headers: auth_headers, as: :json
        end.to change(Material, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json['message']).to eq('Material created successfully')
      end
    end

    context 'when authorized and params are invalid' do
      it 'returns 422' do
        expect do
          post api_base, params: { material: invalid_attributes }, headers: auth_headers, as: :json
        end.not_to change(Material, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /api/kapi/v1/materials/:id' do
    let(:new_attributes) { { name: 'Updated Bean', cost: 90.0, quantity: 3, cost_per_unit: 30.0 } }

    context 'when unauthorized' do
      it 'returns 401' do
        patch "#{api_base}/#{material.id}", params: { material: new_attributes }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized and params are valid' do
      it 'updates the material' do
        patch "#{api_base}/#{material.id}", params: { material: new_attributes }, headers: auth_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(material.reload.name).to eq('Updated Bean')
      end
    end

    context 'when authorized and params are invalid' do
      it 'returns 422' do
        patch "#{api_base}/#{material.id}", params: { material: invalid_attributes }, headers: auth_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/kapi/v1/materials/:id' do
    context 'when unauthorized' do
      it 'returns 401' do
        delete "#{api_base}/#{material.id}", as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized and material is not in use' do
      it 'deletes the material' do
        expect do
          delete "#{api_base}/#{material.id}", headers: auth_headers, as: :json
        end.to change(Material, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authorized and material is in use' do
      it 'returns conflict' do
        allow(Ingredient).to receive(:exists?).with(material_id: material.id).and_return(true)

        delete "#{api_base}/#{material.id}", headers: auth_headers, as: :json

        expect(response).to have_http_status(:conflict)
      end
    end
  end
end
