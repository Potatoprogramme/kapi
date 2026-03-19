# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  validates :name, presence: true
  has_one :product, dependent: :nullify
end
