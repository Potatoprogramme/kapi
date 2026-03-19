# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail
  has_many :ingredients, dependent: :destroy # on delete: cascade
  has_many :materials, through: :ingredients # join materials
  has_many :ingredient_costings, through: :ingredients
  has_one :product_costing, dependent: :destroy
  validates :thumbnail, :name, presence: true
  belongs_to :product_category
  enum :status, { deleted: 0, active: 1, inactive: 2 }, default: :active
end
