# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Kapi::V1::Materials', type: :request do
  let(:user) { create(:user) }
  let(:api_base) { '/api/kapi/v1/materials' }
  let!(:material) { create(:material, user: user) }
  let(:valid_attributes) do
    attributes_for(:material).merge(user_id: user.id)
  end
  before do
    # Log in the user to get the access token
    post '/api/kapi/v1/auth/login', params: { user: { email_address: user.email_address,
                                                      password: user.password } }, as: :json
    @access_token = response.parsed_body['access_token']
    @refresh_token = response.parsed_body['refresh_token']
  end

  describe 'GET /api/kapi/v1/materials' do
    it 'returns a list of materials' do
      get api_base, as: :json
      expect(response).to have_http_status(:ok)
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
      context 'with valid parameters' do
        it 'creates a new material' do
          post api_base, headers: { 'Authorization' => "Bearer #{@access_token}" },
                         params: { material: valid_attributes }, as: :json
          expect(response).to have_http_status(:created)
          expect(response.parsed_body['data']['name']).to eq(valid_attributes[:name])
        end
      end
      context 'with invalid parameters' do
        it 'returns unprocessable entity' do
          post api_base, headers: { 'Authorization' => "Bearer #{@access_token}" },
                         params: { material: valid_attributes.merge(name: nil) }, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        post api_base, params: { material: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
