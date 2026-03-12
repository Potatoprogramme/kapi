# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail
  has_many :ingredients, dependent: :destroy # on delete: cascade
  has_many :materials, through: :ingredients # join materials
  has_one :product_category, dependent: :nullify
  validates :thumbnail, :name, presence: true
end
