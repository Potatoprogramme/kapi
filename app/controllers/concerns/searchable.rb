# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    helper_method :initialize_search_options, :initialize_status_cards
  end

  private

  def initialize_search_options
    @search    = params[:search]
    @category  = params[:category]
    @page      = params[:page]
    @sort      = params[:sort].presence || 'name'
    @direction = params[:direction].presence || 'asc'

    # Derived state for the UI
    @next_direction = (@direction == 'asc' ? 'desc' : 'asc')

    # For Product
    @categories = ProductCategory.all
  end

  def initialize_status_cards
    @bean_types = Material.count
    @total_investment = Material.sum(:cost)
    @unit_types = Material.distinct.pluck(:unit).compact
  end
end
