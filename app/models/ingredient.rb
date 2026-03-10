class Ingredient < ApplicationRecord
  belongs_to :materials
  belongs_to :product
end
