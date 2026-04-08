# frozen_string_literal: true

json.message 'Category updated successfully!'
json.data do
  json.partial! 'category', category: @category
end
