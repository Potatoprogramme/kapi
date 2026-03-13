# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail
  has_many :ingredients, dependent: :destroy # on delete: cascade
  has_many :materials, through: :ingredients # join materials
  validates :thumbnail, :name, :product_category_id, presence: true
end
