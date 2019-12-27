require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

helper = AdventHelper.new(script_root:__dir__)

input = helper.comma_separated_strings('input.txt').map(&:to_i)

# Part 1
# p (0..49).to_a.repeated_permutation(2).count { |pos|
#   IntcodeComputer.new(input, IntcodeIO.new(pos)).run.first == 1
# }

# Part 2
# map = Hash.new
# (0..49).to_a.repeated_permutation(2).each { |pos|
#   map[pos] = IntcodeComputer.new(input, IntcodeIO.new(pos.dup)).run.first
# }


animate = true
map = Hash.new
x = 0r
y = 5
first_x = 0
while true
  x = first_x
  while true
    output = IntcodeComputer.new(input, IntcodeIO.new([x, y])).run.first
    if output == 1
      map[[x, y]] = true
      first_x = x
      break
    end
    x += 1
  end
  if map[[x+99,y-99]]
    p [x,y]
    p (x * 10000) + (y-99)
    break
  end
  x += 1
  while true
    output = IntcodeComputer.new(input, IntcodeIO.new([x, y])).run.first
    if output == 1
      map[[x, y]] = true
    else
      break
    end
    x += 1
  end
  y += 1
end

(0..49).each do |y|
  
end