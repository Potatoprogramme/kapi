# frozen_string_literal: true

class CreateMaterials < ActiveRecord::Migration[8.1]
  def change
    create_table :materials do |t|
      t.string :name
      t.float :quantity
      t.float :cost
      t.float :cost_per_unit
      t.string :unit

      t.timestamps
    end
  end
end
