class MaterialsQuery < ApplicationQuery
  attr_reader :relation, :params

  # Default relation is Material.all, but you can pass a specific scope
  def initialize(params, relation = Material.all)
    @relation = relation
    @params = params
  end

  def call
    # We chain the private methods to refine the query
    query = relation
    query = filter_by_category(query)
    query = filter_by_status(query)
    search(query)

    # Return the final ActiveRecord::Relation
  end

  private

  def filter_by_category(scoped)
    return scoped if params[:category_id].blank?

    scoped.where(category_id: params[:category_id])
  end

  def filter_by_status(scoped)
    return scoped if params[:status].blank?

    scoped.where(status: params[:status])
  end

  def search(scoped)
    return scoped if params[:query].blank?

    # Using 'ILIKE' for case-insensitive search in PostgreSQL
    scoped.where('name ILIKE ?', "%#{params[:query]}%")
  end
end
