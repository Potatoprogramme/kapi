# frozen_string_literal

json.message 'Category created successfully!'
json.data do
  json.partial! 'category', category: @category
end
