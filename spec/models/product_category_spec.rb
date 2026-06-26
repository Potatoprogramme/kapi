# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  let(:user) { build(:user) }
  let(:product_category) { build(:product_category, user: user) }

  describe 'validations' do
    it 'is valid with a valid factory object' do
      expect(product_category).to be_valid
    end

    it 'requires a name' do
      product_category.name = nil

      expect(product_category).not_to be_valid
      expect(product_category.errors[:name]).to include("can't be blank")
    end

    it 'requires a user' do
      product_category.user = nil

      expect(product_category).not_to be_valid
      expect(product_category.errors[:user]).to include('must exist')
    end
  end
end
