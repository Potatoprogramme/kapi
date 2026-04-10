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
    post '/api/kapi/v1/login', params: { user: {
      email_address: user.email_address,
      password: user.password
    } }, as: :json

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body['access_token']).to be_present
    token = response.parsed_body['access_token']

    { 'Authoriazation' => "Bearer #{token}" }
  end
end
RSpec.describe 'Api::Kapi::V1::ProductCategories', type: :request do
  let(:product_category) { create(:product_category) }
  describe 'GET /api/kapi/v1/product_categories' do
    it 'returns a list of product categories' do
      get '/api/kapi/v1/product_categories', as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['total']).to eq(1)
    end
  end
end
