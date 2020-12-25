require_relative '../../lib/advent_helper'
require 'set'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse

# Part 1
VECTORS = {
  'e' => [1,0],
  'se' => [1,-1],
  'sw' => [0,-1],
  'w' => [-1,0],
  'nw' => [-1,1],
  'ne' => [0,1]
}

paths = []
input.each do |tile|
  string = tile.dup
  output = []
  until string.length == 0
    if ["w", "e"].include?(string[0])
      output << string[0]
      string = string[1..-1]
    else
      output << string[0..1]
      string = string[2..-1]
    end
  end
  paths << output
end

tiles = Hash.new
paths.each do |path|
  position = [0,0]
  path.each do |step|
    position = position.zip(VECTORS[step]).map(&:sum)
  end
  if tiles[position]
    tiles.delete(position)
  else
    tiles[position] = true
  end
end

a = tiles.values.count

# Part 2

def is_black(grid, pos)
  count = VECTORS.values.count do |vector|
    grid[pos.zip(vector).map(&:sum)]
  end
  currently_black = grid[pos]
  return false if currently_black && count == 0
  return false if currently_black && count > 2
  return true if !currently_black && count == 2
  currently_black
end

def points_to_check(grid)
  all_points = Set.new
  grid.keys.each do |pos|
    points = VECTORS.values.map { |v| v.zip(pos).map(&:sum) } + [pos]
    all_points.merge(points)
  end
  all_points
end

def frame_string(grid, scale = 70)
  lines = scale.downto(-scale).map do |y|
    line = (-scale..scale).map do |x|
      grid[[x, y]] ? "😆" : "  "
    end
    " " * (y + scale) + line.join
  end .join("\n")
  lines
end

# p points_to_check({[10,10] => true, [0, 0] => true}).count -> 14

animate = false
frames = []

grid = tiles.dup
if animate
  frames << grid
end

100.times do
  new_tiles = Hash.new
  points_to_check(grid).each do |pos|
    if is_black(grid, pos)
      new_tiles[pos] = true
    end
  end
  grid = new_tiles
  if animate
    frames << grid
  end
end

b = grid.values.count


helper.output(a, b)

if animate
  strings = frames.map do |grid|
    frame_string(grid)
  end

  strings.each do |string|
    print "\e[H"
    puts string
    sleep 0.1
  end
end




