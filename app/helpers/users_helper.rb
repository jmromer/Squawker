module UsersHelper

  def avatar_for(user, options = { size: 128 })
    if is_a_dummy?(user)
      get_gravatar_for(user, options)
    else
      avatar_url = user.image_url
      image_tag(avatar_url, alt: user.name, class: 'gravatar')
    end
  end

  def is_a_dummy?(user)
    (user.email =~ /.+@example.com$/).nil?
  end

  def get_gravatar_for(user, options)
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    size         = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end



