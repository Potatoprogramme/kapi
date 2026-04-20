# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductCosting, type: :model do
  let(:product) { create(:product) }

  let(:valid_attributes) do
    {
      product: product,
      overhead_percentage: 20,
      profit_margin_percentage: 20,
      direct_cost: 100,
      overhead_cost: 20,
      total_cost: 120,
      profit_margin_amount: 30,
      selling_price: 150
    }
  end

  subject(:product_costing) { described_class.new(valid_attributes) }

  describe 'validations' do
    it 'is valid with consistent costing values' do
      expect(product_costing).to be_valid
    end

    it 'requires product' do
      product_costing.product = nil

      expect(product_costing).not_to be_valid
      expect(product_costing.errors[:product]).to include('must exist')
    end

    it 'requires all costing fields to be present' do
      required_fields = %i[
        overhead_percentage
        profit_margin_percentage
        direct_cost
        overhead_cost
        total_cost
        profit_margin_amount
        selling_price
      ]

      required_fields.each do |field|
        record = described_class.new(valid_attributes.merge(field => nil))

        expect(record).not_to be_valid
        expect(record.errors[field]).to include("can't be blank")
      end
    end
  end

  describe '#costing_values_are_consistent' do
    it 'is invalid when profit_margin_percentage is 100 or more' do
      product_costing.profit_margin_percentage = 100

      expect(product_costing).not_to be_valid
      expect(product_costing.errors[:profit_margin_percentage]).to include('must be less than 100')
    end

    it 'is invalid when derived values are inconsistent' do
      product_costing.overhead_cost = 99

      expect(product_costing).not_to be_valid
      expect(product_costing.errors[:base]).to include('Costing values are inconsistent')
    end

    it 'allows small rounding differences within tolerance' do
      product_costing.overhead_cost = 20.01
      product_costing.total_cost = 120.01
      product_costing.profit_margin_amount = 30.01

      expect(product_costing).to be_valid
    end
  end
end
