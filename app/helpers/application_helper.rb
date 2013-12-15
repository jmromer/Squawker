module ApplicationHelper

  def full_title(page_title)
    base_title = "Squawker"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def trash_can_icon
    trash_icon_url = "http://s3.amazonaws.com/squawker/icon_trash.gif"
    image_tag( trash_icon_url,
                border: 0,
                alt: 'Delete',
                title: 'Delete',
                class: 'trashcan' )
  end


end