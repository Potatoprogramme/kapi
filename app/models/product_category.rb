# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  validates :name, :color, presence: true
  has_one :
end
