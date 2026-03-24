class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.text :item_name
      t.decimal :quantity
      t.decimal :cost_per_item
      t.decimal :item_total_cost

      t.timestamps
    end
  end
end
