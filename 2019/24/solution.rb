require_relative '../../lib/advent_helper'

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
map = input.dup
known = Hash.new
current_rating = rating(map)

print_map(map)

while true
  break if known[current_rating]
  known[current_rating] = true
  map = tick(map)
  current_rating = rating(map)
  print_map(map)
end
p current_rating


# Part 2
input
