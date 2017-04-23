module Enumerable
  def pmap
    return to_enum(:pmap) unless block_given?

    if count < 2
      map { |e| yield(e) }
    else
      map { |e| Thread.new { yield(e) } }.map(&:value)
    end
  end
end
