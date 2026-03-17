# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail
  has_many :ingredients, dependent: :destroy # on delete: cascade
  has_many :materials, through: :ingredient # join materials
  validates :thumbnail, :name, presence: true
  belongs_to :product_category
end
