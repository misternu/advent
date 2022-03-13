require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')

DIRECTIONS = [
  [0,-1],
  [1,-1],
  [1,0],
  [1,1],
  [0,1],
  [-1,1],
  [-1,0],
  [-1,-1]
].freeze

# unique integers for each coordinate
def x_y_to_int(x, y, width)
  y * width + x
end

# just in case
# def int_to_x_y(int, width)
#   [int % width, int / width]
# end

def neighbor_ints(x, y, width)
  DIRECTIONS.filter_map do |dx, dy|
    next if x + dx < 0
    next if y + dy < 0
    next if x + dx >= width
    x_y_to_int(x+dx, y+dy, width)
  end
end

taken = Hash.new
neighbor_keys = Hash.new
height = input.length
width = input.first.length
input.each_with_index do |l, y|
  l.split('').each_with_index do |c, x|
    next if c == "."
    key = x_y_to_int(x, y, width)
    taken[key] = :L
    neighbor_keys[key] = neighbor_ints(x, y, width)
  end
end

while true
  new_taken = Hash.new
  taken.keys.each do |pos|
    if taken[pos] == :T
      count = neighbor_keys[pos].count { |n_pos| taken[n_pos] == :T }
      new_taken[pos] = count > 3 ? :L : :T
    else
      none = neighbor_keys[pos].none? { |n_pos| taken[n_pos] == :T }
      new_taken[pos] = none ? :T : :L
    end
  end
  break unless new_taken.any? { |k, v| taken[k] != v }
  taken = new_taken
end

a = taken.values.count(:T)


class LineOfSight
  def initialize(x, y, width, height, seats)
    @x, @y, @width, @height, @seats = x, y, width, height, seats
  end

  def neighbors
    DIRECTIONS.filter_map do |dx, dy|
      distant_neighbor(dx, dy)
    end
  end

  def distant_neighbor(dx, dy)
    nx, ny = @x + dx, @y + dy
    while on_map(nx, ny)
      seat_num = x_y_to_int(nx, ny, @width)
      return seat_num if @seats.include?(seat_num)
      nx += dx
      ny += dy
    end
    nil
  end

  def on_map(x, y)
    return false if x < 0
    return false if y < 0
    return false if x >= @width
    return false if y >= @height
    true
  end
end

# part 2 data
neighbor_keys = Hash.new
input.each_with_index do |l, y|
  l.split('').each_with_index do |c, x|
    next if c == "."
    key = x_y_to_int(x, y, width)
    taken[key] = :L
    neighbor_keys[key] = LineOfSight.new(x, y, width, height, taken.keys).neighbors
  end
end

while true
  new_taken = Hash.new
  taken.keys.each do |pos|
    if taken[pos] == :T
      count = neighbor_keys[pos].count { |n_pos| taken[n_pos] == :T }
      new_taken[pos] = count > 4 ? :L : :T
    else
      none = neighbor_keys[pos].none? { |n_pos| taken[n_pos] == :T }
      new_taken[pos] = none ? :T : :L
    end
  end
  break unless new_taken.any? { |k, v| taken[k] != v }
  taken = new_taken
end

b = taken.values.count(:T)

helper.output(a, b)
