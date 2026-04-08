# frozen_string_literal: true

json.message 'Material created successfully'
json.data do
  json.partial! 'material', material: @material
end
