# frozen_string_literal: true

json.extract! material,
              :id,
              :cost,
              :name,
              :quantity,
              :unit,
              :cost_per_unit,
              :user_id,
              :created_at,
              :updated_at
json.cost_per_unit material.cost_per_unit.to_f
