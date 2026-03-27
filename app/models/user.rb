# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :materials, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
