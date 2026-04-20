# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Material, type: :model do
  let(:user) { build(:user) }
  let(:material) { build(:material, user: user) }

  describe 'validations' do
    it 'is valid with a valid factory object' do
      expect(material).to be_valid
    end

    it 'requires a name' do
      material.name = nil

      expect(material).not_to be_valid
      expect(material.errors[:name]).to include("can't be blank")
    end

    it 'requires cost to be present' do
      material.cost = nil

      expect(material).not_to be_valid
      expect(material.errors[:cost]).to include("can't be blank")
    end

    it 'requires quantity to be present' do
      material.quantity = nil

      expect(material).not_to be_valid
      expect(material.errors[:quantity]).to include("can't be blank")
    end

    describe 'unit' do
      it 'requires a unit' do
        material.unit = nil

        expect(material).not_to be_valid
        expect(material.errors[:unit]).to include("can't be blank")
      end

      it 'is valid when the unit is within options' do
        Material::VALID_UNITS.each do |unit|
          material.unit = unit
          expect(material).to be_valid
        end
      end

      it 'is invalid when the unit is outside the allowed values' do
        material.unit = 'bags'

        expect(material).not_to be_valid
        expect(material.errors[:unit]).to include('is not included in the list')
      end
    end

    describe 'cost_per_unit' do
      it 'requires cost_per_unit to be present' do
        material.cost_per_unit = nil

        expect(material).not_to be_valid
        expect(material.errors[:cost_per_unit]).to include("can't be blank")
      end

      it 'is valid when cost_per_unit matches cost divided by quantity' do
        material.cost_per_unit = (material.cost.to_f / material.quantity.to_f).round(3)

        expect(material).to be_valid
      end

      it 'is invalid when cost_per_unit does not match the calculation' do
        material.cost_per_unit = (material.cost.to_f / material.quantity.to_f).round(3) + 1

        expect(material).not_to be_valid
        expect(material.errors[:cost_per_unit].first).to match(/must equal cost divided by\s+quantity/)
      end
    end
  end
end
