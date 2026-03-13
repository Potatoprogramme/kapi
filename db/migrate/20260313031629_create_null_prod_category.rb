# frozen_string_literal: true

class CreateNullProdCategory < ActiveRecord::Migration[8.1]
  def change
    # Column must allow NULL for ON DELETE SET NULL
    change_column_null :products, :product_category_id, true

    # Replace existing FK (if present) with ON DELETE SET NULL
    if foreign_key_exists?(:products, :product_categories, column: :product_category_id)
      remove_foreign_key :products, column: :product_category_id
    end

    add_foreign_key :products, :product_categories, column: :product_category_id, on_delete: :nullify
  end
end
