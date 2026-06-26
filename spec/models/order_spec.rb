# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { build(:user) }
  let(:order) { build(:order, user: user) }

  describe 'validations' do
    it 'is valid with a valid factory object' do
      expect(order).to be_valid
    end

    it 'requires order_total' do
      order.order_total = nil

      expect(order).not_to be_valid
      expect(order.errors[:order_total]).to include("can't be blank")
    end

    it 'requires payment_method' do
      order.payment_method = nil

      expect(order).not_to be_valid
      expect(order.errors[:payment_method]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = Order.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many order_items dependent on destroy' do
      association = Order.reflect_on_association(:order_items)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'destroys associated order items' do
      user = create(:user)
      order = create(:order, user: user)
      product = create(:product)
      create(:order_item, order: order, product: product)

      expect do
        order.destroy
      end.to change(OrderItem, :count).by(-1)
    end
  end

  describe 'enums' do
    it 'defines payment methods' do
      expect(Order.payment_methods).to include('cash', 'gcash', 'card', 'maya')
    end

    it 'defines order statuses' do
      expect(Order.statuses).to include('pending', 'completed', 'voided')
    end
  end
end
