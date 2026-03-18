class CreateProductCostingTable < ActiveRecord::Migration[8.1]
  def change
    create_table :product_costings do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :overhead_percentage
      t.decimal :profit_margin_percentage
      t.decimal :direct_cost
      t.decimal :overhead_cost
      t.decimal :profit_margin_amount
      t.decimal :selling_price

      t.timestamps
    end
  end
end
