module SquawksHelper

  def parse_urls(str)
    str.gsub(/(?<link>https?:\/\/[\/\w\d\.-]+)/i, '<a href="\k<link>">\k<link></a>').html_safe
  end

  def parse_mentions(str)
    str.gsub(/(?<link>@\w+)/i, '<a href="http://twitter.com/\k<link>">\k<link></a>').html_safe
  end

  def parse_hashtags(str)
    hash_tags = str.scan(/#\w+/).uniq
    if hash_tags.empty?
      str
    else
      str.split.map do |substr|
        if hash_tags.include? substr
          substr.gsub(substr, "<a href=\"http://twitter.com/search?q=%23#{substr[1..-1]}\">#{substr}</a>")
        else
          substr
        end
      end.join(' ').html_safe
    end
  end

  def formatted(str)
    parse_hashtags(parse_mentions(parse_urls(wrap(str))))
  end

  def wrap(content, options={max_length: 70})
    max = options[:max_length]

    wrapped_string = content.split.map do |s|
      s.length > max ? wrap_long_string(s, max) : s
    end.join(' ')

    sanitize(raw(wrapped_string))
  end

  def wrap_long_string(text, max_length)
    zero_width_space    = "&#8203;"
    string_upto_max_len = /.{1,#{max_length}}/
    text.scan(string_upto_max_len).join(zero_width_space)
  end
end
