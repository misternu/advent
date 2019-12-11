require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'
require 'set'

helper = AdventHelper.new(script_root:__dir__)

input = helper.comma_separated_strings('input.txt').map(&:to_i)

# Part 1
floor = Hash.new(1)
locations_painted = Set.new
position = [0,0]
direction = 0
computer = IntcodeComputer.new(input, IntcodeIO.new(), wait: true)
minx, maxx, miny, maxy = 0, 42, -5, 0
while !computer.stopped
  puts`clear`
  puts (maxy.downto(miny)).map { |row|
    (minx..maxx).map { |col| floor[[col, row]] == 1 ? "#" : " " }.join
  }.join("\n")
  sleep 0.02
  computer.io.add(floor[position])
  computer.resume
  color = computer.io.shift
  computer.resume
  turn = computer.io.shift
  locations_painted.add(position)
  floor[position] = color
  if turn == 0
    direction = (direction - 1) % 4
  else
    direction = (direction + 1) % 4
  end
  case direction
  when 0
    position = [position[0], position[1] + 1]
  when 1
    position = [position[0] + 1, position[1]]
  when 2
    position = [position[0], position[1] - 1]
  when 3
    position = [position[0] - 1, position[1]]
  end
end
# Part 1
# p locations_painted.count

# Part 2
# xs = locations_painted.map(&:first)
# p minx = xs.min
# p maxx = xs.max
# ys = locations_painted.map(&:last)
# p miny = ys.min
# p maxy = ys.max

# (maxy.downto(miny)).map do |row|
#   puts (minx..maxx).map { |col| floor[[col, row]] == 1 ? "#" : " " }.join
# end 