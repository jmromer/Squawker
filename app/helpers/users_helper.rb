module UsersHelper

  def gravatar_for(user, options = { size: 130 })
    if (user.email =~ /.+@example.com$/).nil?
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: 'gravatar')
    else
      image_tag(user.image_url, alt: user.name, class: 'gravatar')
    end
  end
end



