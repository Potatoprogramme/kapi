# frozen_string_literal: true

class CreateProductCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.string :description
      t.string :color

      t.timestamps
    end
  end
end
