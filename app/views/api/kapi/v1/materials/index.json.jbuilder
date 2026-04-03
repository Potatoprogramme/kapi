# frozen_string_literal: true

json.materials do
  json.array! @materials do |material|
    json.partial! 'api/kapi/v1/materials/material', material: material
  end
end
json.total @materials.count
