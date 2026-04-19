# frozen_string_literal: true

class MaterialsQuery < ApplicationQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 6

  def initialize(params = {})
    super()
    @search  = params[:search].to_s.strip
    @page    = params[:page] || DEFAULT_PAGE
    @per     = params[:per] || DEFAULT_PER_PAGE
    @sort    = params[:sort] || 'name'
    @direction = params[:direction] || 'asc'
  end

  def call
    Material
      .search_by_name(@search)
      .ordered_by(@sort, @direction)
      .page(@page)
      .per(@per)
  end
end
