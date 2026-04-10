# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'unauthorized user' do |request_call|
  context 'when user is not authenticated' do
    it 'returns unauthorized' do
      instance_exec(&request_call)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_context 'authenticated request' do
  let(:user) { create(:user) }

  let(:auth_headers) do
    post '/api/kapi/v1/auth/login',
         params: { user: { email_address: user.email_address, password: user.password } },
         as: :json

    expect(response).to have_http_status(:ok)
    token = response.parsed_body['access_token']
    expect(token).to be_present

    { 'Authorization' => "Bearer #{token}" }
  end
end

RSpec.describe 'Api::Kapi::V1::Materials', type: :request do
  include_context 'authenticated request'
  let(:api_base) { '/api/kapi/v1/materials' }
  let!(:material) { create(:material, user: user) }
  let(:valid_attributes) { attributes_for(:material) }

  describe 'GET /api/kapi/v1/materials' do
    it 'returns a list of materials' do
      get api_base, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['total']).to eq(1)
    end
  end

  describe 'GET /api/kapi/v1/materials/:id' do
    it 'returns a specific material' do
      get "#{api_base}/#{material.id}", as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['id']).to eq(material.id)
    end
  end

  describe 'POST /api/kapi/v1/materials' do
    context 'when user is authenticated' do
      it 'creates a new material' do
        post api_base,
             headers: auth_headers,
             params: { material: valid_attributes },
             as: :json

        expect(response).to have_http_status(:created)
        expect(response.parsed_body['data']['name']).to eq(valid_attributes[:name])
      end

      it 'returns unprocessable entity with invalid params' do
        post api_base,
             headers: auth_headers,
             params: { material: valid_attributes.merge(name: nil) },
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it_behaves_like 'unauthorized user', lambda {
      post api_base, params: { material: valid_attributes }, as: :json
    }
  end

  describe 'PATCH /api/kapi/v1/materials/:id' do
    context 'when user is authenticated' do
      it 'returns success and updated material' do
        update_attributes = attributes_for(:material).merge(name: 'New material name')

        patch "#{api_base}/#{material.id}",
              headers: auth_headers,
              params: { material: update_attributes },
              as: :json

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']['id']).to eq(material.id)
        expect(response.parsed_body['data']['name']).to eq('New material name')
      end

      it 'returns unprocessable content with invalid params' do
        patch "#{api_base}/#{material.id}",
              headers: auth_headers,
              params: { material: valid_attributes.merge(name: nil) },
              as: :json

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body['error']).to be_present
      end
    end

    it_behaves_like 'unauthorized user', lambda {
      patch "#{api_base}/#{material.id}",
            params: { material: valid_attributes.merge(name: 'X') },
            as: :json
    }
  end

  describe 'DEL /api/kapi/v1/materials/:id' do
    context 'when user is authenticated' do
      it 'returns success if valid material id' do
        delete "#{api_base}/#{material.id}", headers: auth_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['message']).to eq('Material deleted successfully')
      end

      it 'returns not found if invalid material id' do
        delete "#{api_base}/21", headers: auth_headers, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['error']['message']).to be_present
      end
    end

    it_behaves_like 'unauthorized user', lambda {
      delete "#{api_base}/#{material.id}", as: :json
    }
  end
end
