# frozen_string_literal: true

class ApplicationQuery
  ALLOWED_DIRECTIONS = %w[asc desc].freeze
  def self.call(...)
    new(...).call
  end
end
