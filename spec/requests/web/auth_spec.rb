# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:user) { create(:user) }

  describe 'POST /session (login)' do
    context 'with valid credentials' do
      it 'logs in and redirects' do
        post session_path,
             params: { email_address: user.email_address, password: user.password }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end

      context 'when invalid credentials' do
        it 'does not login with wrong password' do
          post session_path, params: { email_address: user.email_address, password: 'wrong' }
          expect(response).to redirect_to(new_session_path)
        end
      end
    end
  end
end
