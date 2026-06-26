# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order_item) { build(:order_item) }

  describe 'associations' do
    it 'is valid with a valid factory object' do
      expect(order_item).to be_valid
    end

    it 'belongs to an order' do
      association = OrderItem.reflect_on_association(:order)

      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a product' do
      association = OrderItem.reflect_on_association(:product)

      expect(association.macro).to eq(:belongs_to)
    end

    it 'requires an order' do
      order_item.order = nil

      expect(order_item).not_to be_valid
      expect(order_item.errors[:order]).to include('must exist')
    end

    it 'requires a product' do
      order_item.product = nil

      expect(order_item).not_to be_valid
      expect(order_item.errors[:product]).to include('must exist')
    end
  end
end
