# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 20_260_326_005_236) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.string 'name', null: false
    t.bigint 'record_id', null: false
    t.string 'record_type', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.string 'content_type'
    t.datetime 'created_at', null: false
    t.string 'filename', null: false
    t.string 'key', null: false
    t.text 'metadata'
    t.string 'service_name', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'ingredient_costings', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.bigint 'ingredient_id', null: false
    t.decimal 'ingredient_total_cost'
    t.decimal 'quantity'
    t.datetime 'updated_at', null: false
    t.index ['ingredient_id'], name: 'index_ingredient_costings_on_ingredient_id'
  end

  create_table 'ingredients', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.bigint 'material_id', null: false
    t.bigint 'product_id', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id'
    t.index ['material_id'], name: 'index_ingredients_on_material_id'
    t.index ['product_id'], name: 'index_ingredients_on_product_id'
    t.index ['user_id'], name: 'index_ingredients_on_user_id'
  end

  create_table 'materials', force: :cascade do |t|
    t.float 'cost'
    t.float 'cost_per_unit'
    t.datetime 'created_at', null: false
    t.string 'name'
    t.float 'quantity'
    t.string 'unit'
    t.datetime 'updated_at', null: false
    t.bigint 'user_id'
    t.index ['user_id'], name: 'index_materials_on_user_id'
  end

  create_table 'order_items', force: :cascade do |t|
    t.decimal 'cost_per_item'
    t.datetime 'created_at', null: false
    t.text 'item_name'
    t.decimal 'item_total_cost'
    t.bigint 'order_id', null: false
    t.bigint 'product_id', null: false
    t.decimal 'quantity'
    t.datetime 'updated_at', null: false
    t.index ['order_id'], name: 'index_order_items_on_order_id'
    t.index ['product_id'], name: 'index_order_items_on_product_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.decimal 'order_total'
    t.integer 'payment_method', default: 0
    t.integer 'status', default: 0
    t.datetime 'updated_at', null: false
    t.bigint 'user_id', null: false
    t.index ['user_id'], name: 'index_orders_on_user_id'
  end

  create_table 'product_categories', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'description'
    t.string 'name'
    t.datetime 'updated_at', null: false
    t.bigint 'user_id'
    t.index ['user_id'], name: 'index_product_categories_on_user_id'
  end

  create_table 'product_costings', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.decimal 'direct_cost'
    t.decimal 'overhead_cost'
    t.decimal 'overhead_percentage'
    t.bigint 'product_id', null: false
    t.decimal 'profit_margin_amount'
    t.decimal 'profit_margin_percentage'
    t.decimal 'selling_price'
    t.decimal 'total_cost'
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_product_costings_on_product_id'
  end

  create_table 'products', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'name'
    t.bigint 'product_category_id'
    t.integer 'status', default: 1, null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id'
    t.index ['product_category_id'], name: 'index_products_on_product_category_id'
    t.index ['user_id'], name: 'index_products_on_user_id'
  end

  create_table 'sessions', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'ip_address'
    t.datetime 'updated_at', null: false
    t.string 'user_agent'
    t.bigint 'user_id', null: false
    t.index ['user_id'], name: 'index_sessions_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'email_address', null: false
    t.string 'password_digest', null: false
    t.datetime 'updated_at', null: false
    t.index ['email_address'], name: 'index_users_on_email_address', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'ingredient_costings', 'ingredients'
  add_foreign_key 'ingredients', 'materials'
  add_foreign_key 'ingredients', 'products'
  add_foreign_key 'ingredients', 'users'
  add_foreign_key 'materials', 'users'
  add_foreign_key 'order_items', 'orders'
  add_foreign_key 'order_items', 'products'
  add_foreign_key 'orders', 'users'
  add_foreign_key 'product_categories', 'users'
  add_foreign_key 'product_costings', 'products'
  add_foreign_key 'products', 'product_categories', on_delete: :nullify
  add_foreign_key 'products', 'users'
  add_foreign_key 'sessions', 'users'
end
