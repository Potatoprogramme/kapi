# frozen_string_literal: true

json.message 'Material created successfully'
json.data do
  json.partial! 'api/kapi/v1/materials/material', material: @material
end
