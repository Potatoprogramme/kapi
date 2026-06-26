# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let(:ingredient) { build(:ingredient) }

  describe 'validations' do
    it 'is valid with a valid factory object' do
      expect(ingredient).to be_valid
    end

    it 'requires quantity' do
      ingredient.quantity = nil

      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:quantity]).to include("can't be blank")
    end

    it 'requires total_cost' do
      ingredient.total_cost = nil

      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:total_cost]).to include("can't be blank")
    end

    it 'requires a material' do
      ingredient.material = nil

      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:material]).to include('must exist')
    end

    it 'requires a product' do
      ingredient.product = nil

      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:product]).to include('must exist')
    end

    it 'requires a user' do
      ingredient.user = nil

      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:user]).to include('must exist')
    end
  end
end
