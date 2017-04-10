# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title)
    base_title = "Squawker"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def trash_can_icon
    <<-HTML.html_safe
      <svg class="trashcan" viewBox="0 0 12 16" version="1.1" aria-hidden="true">
        <path fill-rule="evenodd" d="M11 2H9c0-.55-.45-1-1-1H5c-.55 0-1 .45-1 1H2c-.55 0-1 .45-1 1v1c0 .55.45 1 1 1v9c0 .55.45 1 1 1h7c.55 0 1-.45 1-1V5c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1zm-1 12H3V5h1v8h1V5h1v8h1V5h1v8h1V5h1v9zm1-10H2V3h9v1z">
        </path>
      </svg>
    HTML
  end

  def cache_key_for_collection(items, location)
    entity = items.first.try(:table_name) || items.first.class.to_s.underscore
    items_count = items.count
    time_of_most_recent_update = items.maximum(:updated_at) .try(:utc) .try(:to_s, :number)
    "#{entity}/#{location}-#{items_count}-#{time_of_most_recent_update}"
  end
end
