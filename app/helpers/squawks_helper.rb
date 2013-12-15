module SquawksHelper

  def wrap(content)
    wrapped_string = content.split.map{|s| wrap_long_string(s)}.join(' ')
    sanitize(raw(wrapped_string))
  end

  private

    def wrap_long_string(text, max_allowable_width=30)
      if text.length >= max_allowable_width
        zero_width_space           = "&#8203;"
        for_string_upto_max_length = /.{1,#{max_allowable_width}}/

        text.scan(for_string_upto_max_length).join(zero_width_space)
      else
        text
      end
    end

end