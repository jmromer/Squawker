# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title)
    base_title = "Squawker"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  # Return a cache key of the form
  # entity-name / mru time / item ids
  #
  # Example:
  # "squawk/20140223060100/1191-24-96-25-907-1348-26-1192-27-1193"
  # "user/20170503060413/3-4-5-6-7-8-9-10-11-12-13-14-15-16-17-18-19-20-21-22"
  def cache_key_for_collection(items)
    entity = items.first.try(:table_name) ||
             items.first.class.to_s.underscore

    ids = items.pluck(:id).join("-")

    mru_time = items
               .max_by(&:updated_at)
               .try(:updated_at)
               .try(:utc)
               .try(:to_s, :number)

    "#{entity}/#{mru_time}/#{ids}"
  end
end
