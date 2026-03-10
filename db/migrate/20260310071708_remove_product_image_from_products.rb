# frozen_string_literal: true

class RemoveProductImageFromProducts < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :product_image, :string
  end
end
