# frozen_string_literal: true

class ProductsQuery < ApplicationQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 8

  def initialize(params = {})
    super()
    @category = params[:category]
    @search = params[:search].to_s.strip
    @page = params[:page] || DEFAULT_PAGE
    @per = params[:per] || DEFAULT_PER_PAGE
    @direction = params[:direction] || 'asc'
  end

  def call
    Product.active
           .search_by_name(@search)
           .filter_by_category(@category, @direction)
           .page(@page)
           .per(@per)
  end
end
