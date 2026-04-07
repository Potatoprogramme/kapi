# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Kapi::V1::Authentication' do
  let(:user) { create(:user) }

  describe 'POST api/kapi/v1/auth/login' do
    context 'user logins with valid credentials' do
      it 'returns a token and success status' do
        post '/api/kapi/v1/auth/login', params: { user: { email_address: user.email_address,
                                                          password: user.password } }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['access_token']).to be_present
        expect(response.parsed_body['refresh_token']).to be_present
      end
    end

    context 'user tries to login with wrong credentials' do
      it 'returns unauthorized access' do
        post '/api/kapi/v1/auth/login', params: { user: { email_address: user.email_address,
                                                          password: nil } }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/kapi/v1/auth/logout' do
    context 'when user is logged in' do
      it 'logs out and clears refresh cookie' do
        post '/api/kapi/v1/auth/login',
             params: { user: { email_address: user.email_address, password: user.password } },
             as: :json

        refresh_token = response.cookies['refresh_token']
        expect(refresh_token).to be_present

        post '/api/kapi/v1/auth/logout',
             headers: {
               'Authorization' => 'Bearer any-token',
               'Cookie' => "refresh_token=#{refresh_token}"
             },
             as: :json

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['message']).to eq('Logged out successfully')
      end
    end

    context 'when refresh token is expired or not provided' do
      it 'returns unauthorized' do
        post '/api/kapi/v1/auth/logout', as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
