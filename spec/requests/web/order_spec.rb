# frozen_string_literal: true

require 'rails_helper'
require_relative 'support/shared_context/web_authentication'
RSpec.describe 'Orders', type: :request do
  include_context 'web authenticated request'
  let!(:order) { create(:order, user: user) }

  describe 'GET /index' do
    it 'assigns all orders to @orders and renders orders index' do
      get orders_path
      expect(response.body).to include(order.name)
      expect(response).to have_http_status(:ok)
    end
  end
end
