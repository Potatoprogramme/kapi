# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  before do
    user = create(:user)
    post session_path, params: { email_address: user.email_address, password: 'password' }
  end
  describe 'GET /index' do
    it 'returns http success' do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
