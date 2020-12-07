require_relative '../../lib/advent_helper'
require 'set'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt').map { |line|
  line.split('').map { |c| c == "#" }
}

example_input = [
  "....#".split('').map { |c| c == "#"},
  "#..#.".split('').map { |c| c == "#"},
  "#..##".split('').map { |c| c == "#"},
  "..#..".split('').map { |c| c == "#"},
  "#....".split('').map { |c| c == "#"}
]

# example_rating = [
#   ".....".split('').map { |c| c == "#"},
#   ".....".split('').map { |c| c == "#"},
#   ".....".split('').map { |c| c == "#"},
#   "#....".split('').map { |c| c == "#"},
#   ".#...".split('').map { |c| c == "#"}
# ]

def    up(pos); [pos[0], pos[1] - 1] end
def right(pos); [pos[0] + 1, pos[1]] end
def  down(pos); [pos[0], pos[1] + 1] end
def  left(pos); [pos[0] - 1, pos[1]] end

def rating(map)
  total = 0
  map.flatten.each_with_index do |v, i|
    total += 1 * (2 ** i) if v
  end
  total
end

def neighbors(pos)
  [up(pos), right(pos), down(pos), left(pos)].select { |pos| pos.all? { |i| i >= 0 && i < 5 } }
end

def alive(map, pos)
  current = map[pos.last][pos.first]
  count = neighbors(pos).count do |n|
    map[n.last][n.first]
  end
  (current && count == 1) || (!current && [1,2].include?(count))
end

def tick(map)
  map.each_with_index.map { |row, y|
    row.each_with_index.map { |c, x|
      alive(map, [x, y])
    }
  }
end

def print_map(map)
  puts `clear`
  puts map.map { |row|
    row.map { |c| c ? "#" : "." }.join
  }.join("\n")
  sleep 0.1
end

# Part 1
animate = false
map = input.dup
known = Hash.new
current_rating = rating(map)

print_map(map) if animate

while true
  break if known[current_rating]
  known[current_rating] = true
  map = tick(map)
  current_rating = rating(map)
  print_map(map) if animate
end
p current_rating


# Part 2
bugs = Hash.new

input.each_with_index do |row, y|
  row.each_with_index do |c, x|
    next if y == 2 && x == 2
    if c
      bugs[[x, y, 0]] = true
    end
  end
end

def neighbors_r(pos)
  x, y, z = pos
  urdl = [up([x, y]), right([x, y]), down([x, y]), left([x, y])]
  normal_neighbors = urdl.select { |coord| coord != [2,2] && coord.all? { |i| i >= 0 && i < 5 } }.map { |n| n + [z] }
  abnormal_neighbors = urdl.reject { |coord| coord != [2,2] && coord.all? { |i| i >= 0 && i < 5 } }
  abnormal_neighbors.map! do |neighbor|
    nx, ny = neighbor
    if ny < 0
      [[2,1,z-1]]
    elsif ny > 4
      [[2,3,z-1]]
    elsif nx < 0
      [[1,2,z-1]]
    elsif nx > 4
      [[3,2,z-1]]
    elsif neighbor == [2,2]
      case [x,y]
      when [2,1]
        (0..4).map { |i| [i,0,z+1] }
      when [3,2]
        (0..4).map { |i| [4,i,z+1] }
      when [2,3]
        (0..4).map { |i| [i,4,z+1] }
      when [1,2]
        (0..4).map { |i| [0,i,z+1] }
      end
    end
  end
  normal_neighbors + abnormal_neighbors.flatten(1)
end

def alive_r(bugs, pos)
  current = bugs[pos]
  count = neighbors_r(pos).count { |p| bugs[p] }
  (current && count == 1) || (!current && [1,2].include?(count))
end

def tick_r(bugs)
  positions_to_check = bugs.keys.to_set
  bugs.keys.each { |bug| positions_to_check.merge(neighbors_r(bug)) }
  new_bugs = Hash.new
  positions_to_check.each do |pos|
    if alive_r(bugs, pos)
      new_bugs[pos] = true
    end
  end
  new_bugs
end

200.times do
  bugs = tick_r(bugs)
end

p bugs.keys.count

