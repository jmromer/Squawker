module UsersHelper

  # Returns the Gravatar for the given user
  def gravatar_for(user, options = { size: 130 })
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end



# unless (user.email =~ /.+@example.com$/)
#   placeholder_url = "http://lorempixel.com/500/500/people"
#   image_tag(placeholder_url, alt: user.name, class: 'gravatar')
# else