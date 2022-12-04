require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read


input = input.split("\n").map do |l|
  l.split(",").map do |n|
    n.split("-").map(&:to_i)
  end
end

# Part 1
a = input.count do |pair|
  x, y = pair
  x_range = (x[0]..x[1]).to_a
  y_range = (y[0]..y[1]).to_a
  common = x_range & y_range
  x_range == common || y_range == common
end

# Part 2
b = input.count do |pair|
  x, y = pair
  x_range = (x[0]..x[1]).to_a
  y_range = (y[0]..y[1]).to_a
  common = x_range & y_range
  common.length > 0
end


helper.output(a, b)
# 00:07:59.55
