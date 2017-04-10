# frozen_string_literal: true

module SquawksHelper
  URLS = /(?<link>https?:\/\/[\/\w\d\.-]+)/i
  MENTIONS = /(?<link>@\w+)/i

  def parse_urls(str)
    str.gsub(URLS, '<a href="\k<link>">\k<link></a>').html_safe
  end

  def parse_mentions(str)
    str.gsub(
      MENTIONS,
      '<a href="http://twitter.com/\k<link>">\k<link></a>'
    ).html_safe
  end

  def parse_hashtags(str)
    hash_tags = str.scan(/#\w+/).uniq
    return str if hash_tags.empty?

    segments = str.split.map { |substr| linkify_hashtag(hash_tags, substr) }
    segments.join(" ").html_safe
  end

  def linkify_hashtag(hash_tags, substr)
    return substr unless hash_tags.include?(substr)
    "<a href=\"http://twitter.com/search?q=%23#{substr[1..-1]}\">#{substr}</a>"
  end

  def formatted(str)
    parse_hashtags(parse_mentions(parse_urls(wrap(str))))
  end

  def wrap(content, options = { max_length: 70 })
    max_length = options[:max_length]

    wrapped = content.split.map { |str| wrap_if_needed(max_length, str) }
    wrapped_string = wrapped.join(" ")

    sanitize(raw(wrapped_string))
  end

  def wrap_if_needed(max, str)
    return str unless str.length > max
    wrap_long_string(str, max)
  end

  def wrap_long_string(text, max_length)
    zero_width_space = "&#8203;"
    string_upto_max_len = /.{1,#{max_length}}/

    text.scan(string_upto_max_len).join(zero_width_space)
  end
end
