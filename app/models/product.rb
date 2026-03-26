# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail
  belongs_to :product_category
  belongs_to :user

  has_many :ingredients, dependent: :destroy # on delete: cascade
  has_many :materials, through: :ingredients # join materials
  has_many :ingredient_costings, through: :ingredients
  has_one :product_costing, dependent: :destroy

  validates :thumbnail, :name, presence: true

  enum :status, { deleted: 0, active: 1 }, default: :active
end
