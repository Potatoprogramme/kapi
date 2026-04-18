# frozen_string_literal: true

module ApplicationHelper
  def materials_pagination_nav(page_info)
    return if page_info.blank? || page_info.total_pages <= 1

    content_tag(:nav, class: 'mt-10 flex flex-col items-center gap-4') do
      safe_join([
                  content_tag(:div, page_summary_text(page_info), class: 'text-sm text-gray-600'),
                  content_tag(:div, class: 'flex flex-wrap items-center justify-center gap-2') do
                    safe_join([
                      pagination_link('Previous', page_info.prev_page, disabled: page_info.prev_page.nil?),
                      (1..page_info.total_pages).map do |page|
                        pagination_link(page, page, current: page == page_info.page)
                      end,
                      pagination_link('Next', page_info.next_page, disabled: page_info.next_page.nil?)
                    ].flatten)
                  end
                ])
    end
  end

  private

  def pagination_link(label, page, current: false, disabled: false)
    classes = ['inline-flex items-center justify-center rounded-lg border px-3 py-2 text-sm font-medium transition']

    if current
      classes << 'border-amber-600 bg-amber-600 text-white'
      return content_tag(:span, label, class: classes.join(' '))
    end

    if disabled || page.blank?
      classes << 'cursor-not-allowed border-gray-200 bg-gray-100 text-gray-400'
      return content_tag(:span, label, class: classes.join(' '))
    end

    classes << 'border-amber-200 bg-white text-amber-700 hover:border-amber-400 hover:bg-amber-50'
    link_to label, materials_path(params.to_unsafe_h.except('controller', 'action', 'page').merge(page: page)),
            class: classes.join(' ')
  end

  def page_summary_text(page_info)
    start_record = ((page_info.page - 1) * page_info.per_page) + 1
    end_record = [page_info.page * page_info.per_page, page_info.total_count].min

    "Showing #{start_record}-#{end_record} of #{page_info.total_count} materials"
  end
end
