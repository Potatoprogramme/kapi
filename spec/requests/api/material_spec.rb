# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Kapi::V1::Materials', type: :request do
  let(:user) { create(:user) }
  let(:api_base) { '/api/kapi/v1/materials' }
  let(:material) { create(:material) }
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
end
