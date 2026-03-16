# frozen_string_literal: true

class CreateIngredientCostings < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredient_costings do |t|
      t.references :ingredients, null: false, foreign_key: true
      t.decimal :quantity
      t.decimal :ingredient_total_cost

      t.timestamps
    end
  end
end
