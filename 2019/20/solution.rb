require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

lines = helper.line_separated_strings('input.txt')

# Part 1
map = Hash.new
lines.each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    if ["#", "."].include?(char)
      map[[x,y]] = char
    end
  end
end

# height = lines.length
# width = lines.first.length
# (0...height).each do |y|
#   puts (0...width).map { |x|
#     map[[x,y]] || ' '
#   }.join
# end

holes = Hash.new

map.keys.each do |x, y|
  next unless map[[x, y]] == '.'
  next if map[[x-1, y]] &&
          map[[x+1, y]] &&
          map[[x, y-1]] &&
          map[[x, y+1]]
  holes[[x,y]] = true
end

holes.keys.each do |x,y|
  if map[[x-1, y]].nil?
    label = lines[y][x-2] + lines[y][x-1]
  end
  if map[[x+1, y]].nil?
    label = lines[y][x+1] + lines[y][x+2]
  end
  if map[[x,y-1]].nil?
    label = lines[y-2][x] + lines[y-1][x]
  end
  if map[[x,y+1]].nil?
    label = lines[y+1][x] + lines[y+2][x]
  end
  holes[[x,y]] = label
end

start_pos = holes.select { |k,v| v == "AA" } .keys.first
end_pos = holes.select { |k,v| v == "ZZ" } .keys.first

neighbors = Hash.new { |h, k| h[k] = [] }

map.select { |k,v| v == '.' }.each do |pos, _|
  x,y = pos
  n = []

  [[x+1,y],[x,y+1],[x-1,y],[x,y-1]].each do |dir|
    if map[dir] == '.'
      n << dir
    end
  end

  if (holes.keys - [start_pos, end_pos]).include?(pos)
    label = holes[pos]
    n << holes.select { |k,v| k != pos && v == label }.keys.first
  end

  neighbors[pos] = n
end

distances = Hash.new
steps = 1
frontier = [start_pos]
while frontier.length > 0
  new_frontier = []
  frontier.each do |pos|
    neighbors[pos].each do |n|
      unless distances[n]
        new_frontier << n
        distances[n] = steps
      end
    end
  end
  frontier = new_frontier
  steps += 1
end

# p distances[end_pos]

# Part 2
parity = Hash.new
height = lines.length
width = lines.first.length
holes.each do |hole|
  x,y = hole.first
  if x == 2 || y == 2 || x == width - 3 || y == height - 3
    # outside
    parity[hole.first] = :outside
  else
    # inside
    parity[hole.first] = :inside
  end
end


def recursive_neighbors(pos, map:, holes:, parity:, start_pos:, end_pos:)
  n = []
  x,y,z = pos
  return [] if [x, y] == end_pos
  [[x+1,y],[x,y+1],[x-1,y],[x,y-1]].each do |dir|
    dx, dy = dir
    next unless map[dir] == '.'
    if holes.keys.include?([dx, dy])
      if [start_pos, end_pos].include?([dx, dy])
        next unless z == 0
      elsif parity[[dx, dy]] == :outside
        next unless z > 0
      end
    end
    n << [dx, dy, z]
  end
  return n if [x, y] == start_pos
  if (holes.keys - [start_pos, end_pos]).include?([x, y])
    label = holes[[x, y]]
    dx, dy = holes.select { |k, v| k != [x, y] && v == label }.keys.first
    if parity[[x, y]] == :outside
      n << [dx, dy, z - 1]
    else
      n << [dx, dy, z + 1]
    end
  end
  n
end

options = { map: map, holes: holes, parity: parity, start_pos: start_pos, end_pos: end_pos}
x, y = start_pos
dx, dy = end_pos
distances = { [x, y, 0] => 0 }
frontier = [[x, y, 0]]
steps = 1
until distances[[dx, dy, 0]]
  new_frontier = []
  frontier.each do |pos|
    recursive_neighbors(pos, options).each do |n|
      unless distances[n]
        new_frontier << n
        distances[n] = steps
      end
    end
  end
  frontier = new_frontier
  steps += 1
end
p distances[[dx, dy, 0]]
