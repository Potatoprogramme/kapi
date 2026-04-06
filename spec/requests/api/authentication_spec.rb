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
        expect(response.parsed_body['token']).to be_present
      end
    end

    context 'user logins with wrong credentials ngani' do
      it 'returns unauthorized access' do
        post '/api/kapi/v1/auth/login', params: { user: { email_address: user.email_address,
                                                          password: nil } }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
