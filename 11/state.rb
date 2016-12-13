class State
  attr_reader :floors, :current, :depth
  def initialize(floors, current = 0, depth = 0)
    @floors = floors
    @current = current
    @depth = depth
  end

  def can_move
    directions = []
    directions << "up" if current < floors.length - 1
    directions << "down" if current > 0
    directions
  end

  def value
    points = 0
    floors.each_with_index do |floor, index|
      points += (floor[0].length + floor[1].length) ** index
    end
    points - depth
  end

  def moves
    directions = can_move
    potential_moves = []

    if directions.include?("up")
      #try to move two gens up
      potential_moves += move_gens(current_gens.combination(2))
      #try to move two chips up
      potential_moves += move_chips(current_chips.combination(2))
      #try to move pairs up
      potential_moves += move_pairs(pairs)
    end

    if directions.include?("down")
      #try to move one gen down
      # potential_moves += move_gens(current_gens.combination(1), -1)
      #try to move one chip down
      potential_moves += move_chips(current_chips.combination(1), -1)
    end

    # Cull the list before potentially resorting to moving one item up alone
    # potential_moves = potential_moves.reject { |move| move.fried? }

    # if potential_moves.empty? && directions.include?("up")
    #   #try to move one gen up
    #   potential_moves += move_gens(current_gens.combination(1))
    #   #try to move one chip up
    #   potential_moves += move_chips(current_chips.combination(1))
    # end

    potential_moves.reject { |move| move.fried? }
  end

  def move_gens(combinations, dir = 1)
    combinations.map do |gens|
      state = floors.clone
      state[current] = [(state[current][0] - gens).sort, state[current][1]]
      state[current + dir] = [(state[current + dir][0] + gens).sort, state[current + dir][1]]
      State.new(state, current + dir, depth + 1)
    end
  end

  def move_chips(combinations, dir = 1)
    combinations.map do |chips|
      state = floors.clone
      state[current] = [state[current][0], (state[current][1] - chips).sort]
      state[current + dir] = [state[current + dir][0], (state[current + dir][1] + chips).sort]
      State.new(state, current + dir, depth + 1)
    end
  end

  def move_pairs(pairs, dir = 1)
    pairs.map do |pair|
      state = floors.clone
      state[current] = [(state[current][0] - [pair]).sort, (state[current][1] - [pair]).sort]
      state[current+dir] = [(state[current + dir][0] + [pair]).sort, (state[current + dir][1] + [pair]).sort]
      State.new(state, current + dir, depth + 1)
    end
  end

  # def moves
  #   neighboring_floors.map do |index|
  #     # One or two microchips
  #     chip_moves = (current_chips.combination(1).to_a + current_chips.combination(2).to_a).map do |chips|
  #       state = floors.clone
  #       state[current] = [state[current][0], (state[current][1] - chips).sort]
  #       state[index] = [state[index][0], (state[index][1] + chips).sort]
  #       State.new(state, index, depth + 1)
  #     end
  #     # One or two generators
  #     gen_moves = (current_gens.combination(1).to_a + current_gens.combination(2).to_a).map do |gens|
  #       state = floors.clone
  #       state[current] = [(state[current][0] - gens).sort, state[current][1]]
  #       state[index] = [(state[index][0] + gens).sort, state[index][1]]
  #       State.new(state, index, depth + 1)
  #     end
  #     # A generator and its chip
  #     pair_moves = pairs.map do |pair|
  #       state = floors.clone
  #       state[current] = [(state[current][0] - [pair]).sort, (state[current][1] - [pair]).sort]
  #       state[index] = [(state[index][0] + [pair]).sort, (state[index][1] + [pair]).sort]
  #       State.new(state, index, depth + 1)
  #     end
  #     [chip_moves, gen_moves, pair_moves]
  #   end .flatten.reject { |move| move.fried? }
  # end

  def fried?
    floors.any? { |floor| (floor[1] - floor[0]).length > 0 && floor[0].length > 0 }
  end

  def solved?
    floors[0...-1].all? { |gen, chip| gen.length == 0 && chip.length == 0 }
  end

  def pairs
    current_gens & current_chips
  end

  def current_gens
    current_floor.first
  end

  def current_chips
    current_floor.last
  end

  def current_floor
    floors[current]
  end

  def ==(other)
    floors == other.floors && current == other.current
  end

  def hash
    [floors, current].hash
  end

  def eql?(other)
    self.hash == other.hash
  end
end