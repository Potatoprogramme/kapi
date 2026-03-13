# frozen_string_literal: true

class SetProductCategoryIdToNullOnDelete < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :products, :product_categories, column: :product_category_id
    add_foreign_key :products, :product_categories, column: :product_category_id, on_delete: :nullify
  end
end
