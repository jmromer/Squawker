module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Squawker"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def trash_can_icon
    image_tag("https://s3.amazonaws.com/squawker/icon_trash.gif",
                border: 0,
                alt: 'Delete',
                title: 'Delete',
                class: 'trashcan')
  end


end