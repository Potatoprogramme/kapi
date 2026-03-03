# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Material, type: :model do
  let(:material) { build(:material) }
  describe 'validations' do
    it 'requires name to be present' do
      expect(material).to be_valid
    end
    it 'requires cost to be present' do
      expect(material).to be_valid
    end
    it 'requires quantity to be present' do
      expect(material).to be_valid
    end
    describe 'unit' do
      it 'requires unit to be present' do
        expect(material).to be_valid
      end
      it 'is valid when the unit is within options' do
        Material::VALID_UNITS.each do |unit|
          material.unit = unit
          expect(material).to be_valid
        end
      end
    end

    describe 'cost_per_unit' do
      it 'requires cost_per_unit to be present' do
        expect(material).to be_valid
      end
      it 'is valid if cost_per_unit is equal to cost divided by quantity' do
        expect(material.cost_per_unit).to equal((material.cost / material.quantity).round(2))
      end
    end
  end
end
