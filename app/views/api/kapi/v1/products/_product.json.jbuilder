# frozen_string_literal: true

json.extract! product,
              :id,
              :user_id,
              :name,
              :product_category_id,
              :status,
              :created_at,
              :updated_at
json.selling_price product.product_costing.selling_price.to_f
if product.thumbnail.attached?
  json.thumbnail do
    json.url url_for(product.thumbnail)
    json.filename product.thumbnail.filename
  end
end
