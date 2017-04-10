# frozen_string_literal: true

module UsersHelper
  def avatar_for(user, options = { size: 128 })
    return get_gravatar_for(user, options) if user.dummy?

    avatar_url = user.image_url
    avatar_url = avatar_url.sub("/128.", "/#{options[:size]}.") if avatar_url
    image_tag(avatar_url, alt: user.name, class: "gravatar")
  end

  def get_gravatar_for(user, options)
    gravatar_id  = Digest::MD5.hexdigest(user.email.downcase)
    size         = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"

    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
