# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with a valid factory object' do
      expect(user).to be_valid
    end

    it 'requires an email address' do
      user.email_address = nil

      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include("can't be blank")
    end

    it 'requires a valid email format' do
      user.email_address = 'invalid-email'

      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include('is invalid')
    end

    it 'downcases and strips the email address' do
      user.email_address = '  TEST@Example.COM  '
      user.save!

      expect(user.email_address).to eq('test@example.com')
    end

    it 'enforces email uniqueness case-insensitively' do
      create(:user, email_address: 'unique@example.com')
      duplicate = build(:user, email_address: 'UNIQUE@example.com')

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email_address]).to include('has already been taken')
    end

    it 'requires a password with a minimum length' do
      user.password = 'short'
      user.password_confirmation = 'short'

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  describe 'associations' do
    it 'has many materials dependent on destroy' do
      association = User.reflect_on_association(:materials)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many ingredients dependent on destroy' do
      association = User.reflect_on_association(:ingredients)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many products dependent on destroy' do
      association = User.reflect_on_association(:products)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many product categories dependent on destroy' do
      association = User.reflect_on_association(:product_categories)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'destroys associated records' do
      user = create(:user)
      create(:material, user: user)
      create(:product_category, user: user)
      create(:product, user: user)

      expect do
        user.destroy
      end.to change(Material, :count).by(-1)
                                     .and change(ProductCategory, :count).by(-1)
                                                                         .and change(Product, :count).by(-1)
    end
  end
end
