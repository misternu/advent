class Disc
  attr_reader :positions, :initial
  def initialize(positions, initial)
    @positions = positions
    @initial = initial
  end

  def open_at_t(time)
    (initial + time) % positions == 0
  end
end