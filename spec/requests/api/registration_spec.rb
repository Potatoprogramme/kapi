# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Kapi::V1::Registration', type: :request do
  let!(:existing_user) { create(:user) }
  let(:api_base) { '/api/kapi/v1/register/user' }

  describe 'POST /api/kapi/v1/register/user' do
    it 'creates user and returns http status created if valid parameters' do
      post api_base, params: {
        user: {
          email_address: 'sample@gmail.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['message']).to be_present
    end

    it 'returns unprocessable content if email is not unique' do
      post api_base, params: {
        user: existing_user
      }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body['error']['message']).to be_present
      expect(response.parsed_body['error']['errors']).to be_present
    end
  end
end
