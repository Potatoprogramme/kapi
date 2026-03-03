# frozen_string_literal: true

class Material < ApplicationRecord
  validates :name,  presence: true
  validates :cost,  presence: true
  validates :quantity, presence: true
  validates :unit, presence: true
  validates :cost_per_unit, presence: true
end
