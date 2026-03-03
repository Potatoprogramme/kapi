# frozen_string_literal: true

class Material < ApplicationRecord
  VALID_UNITS = %w[grams ml pieces].freeze
  validates :name,  presence: true
  validates :cost,  presence: true
  validates :quantity, presence: true
  validates :unit, presence: true, inclusion: { in: VALID_UNITS }
  validates :cost_per_unit, presence: true
end
