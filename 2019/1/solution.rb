require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt')

# Part One
p input.map(&:to_i).map { |n| (n/3) - 2}.sum

# Part Two
def fuel_for(number)
  total = 0
  left = number
  until left == 0
    left = [(left/3) - 2, 0].max
    total += left
  end
  total
end

p input.map(&:to_i).map { |n| fuel_for(n) }.sum