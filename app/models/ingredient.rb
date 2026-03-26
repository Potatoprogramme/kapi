# frozen_string_literal: true

class Ingredient < ApplicationRecord
  belongs_to :material
  belongs_to :product
  belongs_to :user
  has_one :ingredient_costing, dependent: :destroy
end
