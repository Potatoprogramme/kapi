# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  has_many :product, dependent: :nullify
end
