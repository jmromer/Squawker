# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title)
    base_title = "Squawker"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def trash_can_icon
    image_tag("icon_trash.gif", border: 0, alt: "Delete",
                                title: "Delete", class: "trashcan")
  end
end
