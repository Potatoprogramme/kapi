# frozen_string_literal: true

json.message 'Updated Successfully'
json.data do
  json.partial! 'material', material: @material
end
