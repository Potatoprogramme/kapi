# frozen_string_literal: true

class MergeIngredientCosting < ActiveRecord::Migration[8.1]
  def change
    drop_table :ingredient_costings do |t|
      t.bigint :ingredient_id, null: false
      t.decimal :quantity
      t.decimal :ingredient_total_cost
      t.timestamps
    end

    change_table :ingredients, bulk: true do |t|
      t.decimal :quantity
      t.decimal :total_cost
    end
  end
end
