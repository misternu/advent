require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse
sample_input = "16,1,2,0,4,2,7,1,2,14".split(',').map(&:to_i)
# input = sample_input


# Part 1
min = input.min
max = input.max

a = (min..max).map { |i| input.map { |j| (i - j).abs }.sum }.min

# Part 2
def fuel(n)
  (n * (n + 1)) / 2
end
b = (min..max).map { |i| input.map { |j| fuel((i - j).abs) }.sum }.min



helper.output(a, b)
