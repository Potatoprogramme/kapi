class RemoveColorFromProductCategories < ActiveRecord::Migration[8.1]
  def change
    remove_column :product_categories, :color, :text
  end
end
