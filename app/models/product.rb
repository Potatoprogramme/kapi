# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail
  belongs_to :product_category
  belongs_to :user

  has_many :ingredients, dependent: :destroy # on delete: cascade
  has_many :materials, through: :ingredients # join materials
  has_one :product_costing, dependent: :destroy

  validates :thumbnail, :name, presence: true

  enum :status, { deleted: 0, active: 1 }, default: :active

  scope :search_by_name, lambda { |term|
    return all if term.blank?

    term = term.to_s.strip
    where('name ILIKE ?', "%#{term}%")
  }

  scope :filter_by_category, lambda { |product_category_id, direction|
    return all if product_category_id.blank?

    safe_category_id = product_category_id.to_i
    safe_direction = ApplicationQuery::ALLOWED_DIRECTIONS.include?(direction) ? direction : 'asc'
    where(product_category_id: safe_category_id).order("name #{safe_direction}")
  }
end
