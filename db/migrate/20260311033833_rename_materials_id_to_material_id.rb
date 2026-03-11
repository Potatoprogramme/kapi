class RenameMaterialsIdToMaterialId < ActiveRecord::Migration[8.1]
  def change
    rename_column :ingredients, :materials_id, :material_id
  end
end
