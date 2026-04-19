# frozen_string_literal: true

class MaterialsQuery < ApplicationQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 6

  def initialize(params = {})
    super()
    @search  = params[:search].to_s.strip
    @page    = params[:page]    || DEFAULT_PAGE
    @per     = params[:per]     || DEFAULT_PER_PAGE
    @sort    = params[:sort]    || 'name'
    @direction = params[:direction] || 'asc'
  end

  def call
    scope = Material.all
    scope = apply_search(scope)
    scope = apply_sort(scope)
    apply_pagination(scope)
  end

  private

  def apply_search(scope)
    return scope if @search.blank?

    scope.where('name ILIKE :search', search: "%#{@search}%")
  end

  def apply_sort(scope)
    # Whitelist allowed columns — never trust raw user input for column names
    allowed_columns = %w[name cost_per_unit unit created_at]

    column    = allowed_columns.include?(@sort) ? @sort : 'name'
    direction = ApplicationQuery::ALLOWED_DIRECTIONS.include?(@direction) ? @direction : 'asc'

    scope.order("#{column} #{direction}")
  end

  def apply_pagination(scope)
    scope.page(@page).per(@per)
  end
end
