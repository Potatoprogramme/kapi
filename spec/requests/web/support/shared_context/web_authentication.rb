# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'web authenticated request' do
  let(:user) { create(:user) }

  before do
    post session_path, params: { email_address: user.email_address, password: user.password }
  end
end
