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
    post '/api/kapi/v1/auth/login', params: { user: {
      email_address: user.email_address,
      password: user.password
    } }, as: :json

    expect(response).to have_http_status(:ok)
    token = response.parsed_body['access_token']
    expect(token).to be_present

    { 'Authorization' => "Bearer #{token}" }
  end
end

RSpec.describe 'Api::Kapi::V1::ProductCategories', type: :request do
  include_context 'authenticated request'
  let(:api_base) { '/api/kapi/v1/product_categories' }
  let!(:product_category) { create(:product_category, user: user) }
  let(:valid_attributes) { attributes_for(:product_category) }
  let(:invalid_attributes) { attributes_for(:product_category).merge(name: nil) }

  # index
  describe 'GET /api/kapi/v1/product_categories' do
    it 'returns a list of product categories' do
      get api_base, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['total']).to eq(1)
    end
  end

  # show
  describe 'GET /api/kapi/v1/product_categories/<id>' do
    it 'returns a specific product category' do
      get "#{api_base}/#{product_category.id}", as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['id']).to eq(product_category.id)
    end
  end

  # create
  describe 'POST /api/kapi/v1/product_categories' do
    context 'when user is authenticated' do
      it 'creates a new product category if valid parameters' do
        post api_base,
             headers: auth_headers,
             params: { category: valid_attributes },
             as: :json
        expect(response).to have_http_status(:created)
        expect(response.parsed_body['data']).to be_present
        expect(response.parsed_body['data']['name']).to eq(valid_attributes[:name])
      end

      it 'returns unprocessable content if invalid parameters' do
        post api_base,
             headers: auth_headers,
             params: { category: invalid_attributes },
             as: :json
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
    it_behaves_like 'unauthorized user', lambda {
      post api_base, as: :json
    }
  end

  # update
  describe 'PATCH /api/kapi/v1/product_categories/<id>' do
    context 'when user is authenticated' do
      it 'updates the category if valid parameters' do
        update_attributes = attributes_for(:product_category).merge(name: 'New category name')
        patch "#{api_base}/#{product_category.id}",
              headers: auth_headers,
              params: { category: update_attributes },
              as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to be_present
        expect(response.parsed_body['data']['id']).to eq(product_category.id)
        expect(response.parsed_body['data']['name']).to eq('New category name')
      end

      it 'returns unprocessable content if invalid parameters' do
        patch "#{api_base}/#{product_category.id}",
              headers: auth_headers,
              params: { category: invalid_attributes },
              as: :json
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'returns not found when id does not exist' do
        patch "#{api_base}/2",
              headers: auth_headers,
              params: { category: invalid_attributes },
              as: :json
        expect(response).to have_http_status(:not_found)
      end
    end

    it_behaves_like 'unauthorized user', lambda {
      patch "#{api_base}/#{product_category.id}"
    }
  end

  # destroy
  describe 'DELETE /api/kapi/v1/<id>' do
    context 'when user is authenticated' do
      it 'returns success and deletes category' do
        delete "#{api_base}/#{product_category.id}",
               headers: auth_headers,
               as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['message']).to eq('Category deleted successfully!')
      end

      it 'returns not found if id does not exist' do
        delete "#{api_base}/2",
               headers: auth_headers,
               as: :json
        expect(response).to have_http_status(:not_found)
      end
    end

    it_behaves_like 'unauthorized user', lambda {
      delete "#{api_base}/#{product_category.id}", as: :json
    }
  end
end
