# frozen_string_literal: true

class AddTotalCostToProductCosting < ActiveRecord::Migration[8.1]
  def change
    add_column :product_costings, :total_cost, :decimal
  end
end
