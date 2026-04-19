# frozen_string_literal: true

class Material < ApplicationRecord
  VALID_UNITS = %w[grams ml pieces].freeze
  belongs_to :user
  validates :name,  presence: true
  validates :cost,  presence: true
  validates :quantity, presence: true
  validates :unit, presence: true, inclusion: { in: VALID_UNITS }
  validates :cost_per_unit, presence: true
  validate :cost_per_unit_matches_calculation

  def cost_per_unit_matches_calculation
    return if cost.blank? || quantity.blank? || cost_per_unit.blank?

    expected = cost.to_f / quantity.to_f
    return unless (cost_per_unit.to_f - expected).abs > 0.001

    errors.add(:cost_per_unit, 'must equal cost divided by
    quantity')
  end

  scope :search_by_name, ->(term) {
    return all if term.blank?
    term = term.to_s.strip
    where('name ILIKE ?', "%#{term}%")
  }

  scope :ordered_by, ->(column = 'name', direction = 'asc') {
    allowed_columns = %w[name cost_per_unit unit created_at]
    allowed_directions = ApplicationQuery::ALLOWED_DIRECTIONS

    safe_column = allowed_columns.include?(column) ? column : 'name'
    safe_direction = allowed_directions.include?(direction) ? direction : 'asc'

    order("#{safe_column} #{safe_direction}")
  }
end
