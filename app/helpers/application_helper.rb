module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "NewsFlash"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def trash_can_icon
    image_tag("icon_trash.gif",
                border: 0,
                alt: 'Delete',
                title: 'Delete',
                class: 'trashcan')
  end


end