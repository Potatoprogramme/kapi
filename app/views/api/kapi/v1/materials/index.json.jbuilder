# frozen_string_literal: true

json.materials do
  json.array! @materials do |material|
    json.partial! 'material', material: material
  end
end
json.total @materials.count
