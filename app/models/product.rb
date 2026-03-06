# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail
  validates :thumbnail, presence: true
  validates :name, presence: true
end
