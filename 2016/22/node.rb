class Node
  attr_reader :pos, :size, :avail, :used
  def initialize(string)
    @pos = /node-x(\d+)-y(\d+)/.match(string).captures.map(&:to_i)
    @size, @used, @avail = /(\d+)T\s*(\d+)T\s*(\d+)T/.match(string).captures.map(&:to_i)
  end

  def empty?
    used == 0
  end
end