# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  has_one :product, dependent: :nullify
end
