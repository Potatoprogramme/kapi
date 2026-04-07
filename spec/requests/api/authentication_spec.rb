# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Kapi::V1::Authentication' do
  let(:user) { create(:user) }

  def login_user
    post '/api/kapi/v1/auth/login', params: { user: { email_address: user.email_address,
                                                      password: user.password } }, as: :json
  end

  describe 'POST /api/kapi/v1/auth/login' do
    context 'user logins with valid credentials' do
      it 'returns a token and success status' do
        login_user
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['access_token']).to be_present
        expect(response.parsed_body['refresh_token']).to be_present
        expect(response.cookies['refresh_token']).to be_present
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

  describe 'POST /api/kapi/v1/auth/refresh' do
    context 'when user is logged in' do
      before do
        login_user
        expect(response).to have_http_status(:ok)
        @refresh_token = response.cookies['refresh_token']
      end

      it 'returns success and a new access token' do
        post '/api/kapi/v1/auth/refresh', headers: {
          'Cookie' => "refresh_token=#{@refresh_token}"
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['access_token']).to be_present
      end
    end

    context 'when refresh token is not provided' do
      it 'should return unauthorized' do
        post '/api/kapi/v1/auth/refresh', as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/kapi/v1/auth/logout' do
    context 'when user is logged in' do
      before do
        login_user
        expect(response).to have_http_status(:ok)
        @refresh_token = response.cookies['refresh_token']
      end

      it 'returns success and clears the refresh token cookie' do
        post '/api/kapi/v1/auth/logout',
             headers: {
               'Cookie' => "refresh_token=#{@refresh_token}"
             },
             as: :json
        expect(response).to have_http_status(:ok)
        expect(response.cookies['refresh_token']).to be_nil
      end
    end

    context 'when refresh token is not provided' do
      it 'should return unauthorized' do
        post '/api/kapi/v1/auth/logout', as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
