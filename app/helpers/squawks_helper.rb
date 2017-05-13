# frozen_string_literal: true

module SquawksHelper
  URLS = /(?<link>https?:\/\/[\/\w\d\.-]+)/i
  MENTIONS = /(?<handle>(?<=@)\w+)/i

  def parse_urls(str)
    str.gsub(URLS, '<a href="\k<link>">\k<link></a>').html_safe
  end

  def parse_mentions(str)
    str.gsub(/@#{MENTIONS}/, '<a href="/users/\k<handle>">@\k<handle></a>').html_safe
  end

  def parse_hashtags(str)
    hash_tags = str.scan(/#\w+/).uniq
    return str if hash_tags.empty?

    segments = str.split.map do |substr|
      linkify_hashtag(hash_tags, substr)
    end

    safe_join([segments.join(" ").html_safe], "")
  end

  def linkify_hashtag(hash_tags, substr)
    return substr unless hash_tags.include?(substr)
    "<a href=\"/search?q=%23#{substr[1..-1]}\">#{substr}</a>"
  end

  def formatted(str)
    str = wrap(str)
    str = parse_urls(str)
    str = parse_mentions(str)
    str = parse_hashtags(str)
    str
  end

  def wrap(content, options = { max_length: 70 })
    max_length = options[:max_length]

    wrapped = content.split.map { |str| wrap_if_needed(max_length, str) }
    wrapped_string = wrapped.join(" ")

    wrapped_string.html_safe
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
