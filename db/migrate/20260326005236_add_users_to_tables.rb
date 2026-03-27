# frozen_string_literal: true

class AddUsersToTables < ActiveRecord::Migration[8.1]
  def change
    add_reference :materials, :user, foreign_key: true
    add_reference :ingredients, :user, foreign_key: true
    add_reference :products, :user, foreign_key: true
    add_reference :product_categories, :user, foreign_key: true
  end
end
