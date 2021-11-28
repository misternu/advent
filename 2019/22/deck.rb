class Deck
  attr_reader :length, :increment, :offset
  def initialize(length, options = {})
    @length = length
    @increment = options.fetch(:increment, 1) % length
    @offset = options.fetch(:offset, 0) % length
  end

  def apply(technique)
    d_i = technique.first
    d_o = technique.last
    @increment = (@increment * d_i) % length
    @offset = (@offset * d_i + d_o) % length
  end

  def apply_all(instructions)
    instructions.each do |technique|
      apply(technique)
    end
  end

  def index_of(n)
    ((n * @increment) + @offset) % @length
  end

  def number_at(i)
    raise NoMethodError
  end
end
