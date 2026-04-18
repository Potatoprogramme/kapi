# frozen_string_literal: true

class Ingredient < ApplicationRecord
  belongs_to :material
  belongs_to :product
  belongs_to :user

  validates :quantity, :total_cost, presence: true
end
