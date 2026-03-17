class ModifyIngredientCostingTable < ActiveRecord::Migration[8.1]
  def change
    rename_column :ingredient_costings, :ingredients_id, :ingredient_id
  end
end
