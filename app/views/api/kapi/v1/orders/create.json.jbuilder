# frozen_string_literal: true

json.message 'Product created succesfully'
json.data do
  json.partial! 'order', order: @order
end
