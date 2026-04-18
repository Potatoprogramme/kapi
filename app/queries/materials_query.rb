class MaterialsQuery < ApplicationQuery
  Result = Struct.new(
    :records,
    :filtered_relation,
    :page,
    :per_page,
    :total_count,
    :total_pages,
    :prev_page,
    :next_page,
    keyword_init: true
  )

  DEFAULT_PER_PAGE = 9

  attr_reader :relation, :params

  def initialize(params, relation = Material.all)
    @relation = relation
    @params = params
  end

  def call
    filtered_relation = apply_filters(relation.order(name: :asc))
    page = page_number(filtered_relation)
    per_page = per_page_number
    total_count = filtered_relation.count
    total_pages = total_count.zero? ? 0 : (total_count.to_f / per_page).ceil
    offset = (page - 1) * per_page
    records = filtered_relation.offset(offset).limit(per_page)

    Result.new(
      records: records,
      filtered_relation: filtered_relation,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: total_pages,
      prev_page: page > 1 ? page - 1 : nil,
      next_page: page < total_pages ? page + 1 : nil
    )
  end

  private

  def apply_filters(scoped)
    scoped = filter_by_category(scoped)
    scoped = filter_by_status(scoped)
    search(scoped)
  end

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

    scoped.where('name ILIKE ?', "%#{params[:query]}%")
  end

  def page_number(scoped)
    requested_page = params[:page].to_i
    requested_page = 1 if requested_page < 1

    total_count = scoped.count
    total_pages = total_count.zero? ? 0 : (total_count.to_f / per_page_number).ceil
    return 1 if total_pages.zero?

    [requested_page, total_pages].min
  end

  def per_page_number
    requested_per_page = params[:per_page].to_i
    requested_per_page = DEFAULT_PER_PAGE if requested_per_page < 1
    requested_per_page
  end
end
