class State
  TOP_FLOOR = 3
  attr_reader :isotopes, :elevator, :depth
  def initialize(isotopes, elevator = 0, depth = 0)
    @isotopes = isotopes.reject { |isotope| isotope == [TOP_FLOOR, TOP_FLOOR] }
    @elevator = elevator
    @depth = depth
  end

  def can_move
    return [1] if elevator == 0
    return [-1] if elevator == TOP_FLOOR
    [1,-1]
  end

  def index_range
    (0...usable_isotopes.length).to_a
  end

  def combinations
    range = index_range
    range.combination(1).to_a + range.combination(2).to_a
  end

  def moves
    moves = []
    can_move.each do |dir|
      combinations.each do |indices|
        # Move one or two generators
        if indices.all? { |index| isotopes[index][0] == elevator }
          state = isotopes.dup
          indices.each { |index| state[index] = [state[index][0] + dir, state[index][1]] }
          moves << State.new(state.sort.reverse, elevator + dir, depth + 1)
        end
        # Move one or two microchips
        # if indices.all? { |index| isotopes[index][1] == elevator }
        #   state = isotopes.dup
        #   indices.each { |index| state[index] = [state[index][0], state[index][1] + dir] }
        #   moves << State.new(state.sort.reverse, elevator + dir, depth + 1)
        # end
      end
      # Move one pair
      index_range.each do |index|
        if isotopes[index][0] == elevator && isotopes[index][1] == elevator
          state = isotopes.dup
          state[index] = [state[index][0] + dir, state[index][1] + dir]
          moves << State.new(state.sort.reverse, elevator + dir, depth + 1)
        end
      end
    end
    moves.uniq.reject { |state| state.fried? }
  end

  def usable_isotopes
    isotopes.include?([0,0]) ? isotopes[0..isotopes.index([0,0])] : isotopes
  end

  def fried?
    isotopes.each do |isotope|
      next if isotope.first == isotope.last
      return true if isotopes.any? { |gen| gen.first == isotope.last }
    end
    false
  end

  def done?
    @isotopes.empty?
  end

  def hash
    [isotopes, elevator].hash
  end

  def ==(other)
    isotopes == other.isotopes && elevator == other.elevator
  end

  def eql?(other)
    self == other
  end
end