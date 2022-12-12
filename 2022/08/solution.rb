require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')

# input = sample_input

input = input.map(&:chars).map { |l| l.map(&:to_i) }

# Part 1
top = {}
bottom = {}
left = {}
right = {}
top_max = Array.new(input.first.length) { -1 }
bottom_max = Array.new(input.first.length) { -1 }
left_max = Array.new(input.length) { -1 }
right_max = Array.new(input.length) { -1 }

# scan from top
(0...input.length).each do |y|
  (0...input.first.length).each do |x|
    num = input[y][x]
    if num > top_max[x]
      top[[x,y]] = true
      top_max[x] = num
    end
  end
end

# bottom
(0...input.length).each do |o_y|
  y = input.length - o_y - 1
  (0...input.first.length).each do |x|
    num = input[y][x]
    if num > bottom_max[x]
      bottom[[x,y]] = true
      bottom_max[x] = num
    end
  end
end

# left
(0...input.first.length).each do |x|
  (0...input.length).each do |y|
    num = input[y][x]
    if num > left_max[y]
      left[[x,y]] = true
      left_max[y] = num
    end
  end
end

# right
(0...input.first.length).each do |o_x|
  x = input.first.length - o_x - 1
  (0...input.length).each do |y|
    num = input[y][x]
    if num > right_max[y]
      right[[x,y]] = true
      right_max[y] = num
    end
  end
end

all_keys = top.keys + bottom.keys + right.keys + left.keys

a = all_keys.uniq.length

# Part 2
scores = Hash.new(1)

# left to right
(0...input.length).each do |y|
  indexes = Array.new(10) { 0 }
  (0...input.first.length).each do |x|
    key = [x,y]
    num = input[y][x]
    scores[key] *= x - indexes[num..].max
    indexes[num] = x
  end
end

# right to left
(0...input.length).each do |y|
  indexes = Array.new(10) { 0 }
  (0...input.first.length).each do |x_o|
    x = input.first.length - x_o - 1
    key = [x,y]
    num = input[y][x]
    scores[key] *= x_o - indexes[num..].max
    indexes[num] = x_o
  end
end

# top to bottom
(0...input.length).each do |x|
  indexes = Array.new(10) { 0 }
  (0...input.first.length).each do |y|
    key = [x,y]
    num = input[y][x]
    scores[key] *= y - indexes[num..].max
    indexes[num] = y
  end
end

# bottom to top
(0...input.length).each do |x|
  indexes = Array.new(10) { 0 }
  (0...input.first.length).each do |y_o|
    y = input.length - y_o - 1
    key = [x,y]
    num = input[y][x]
    scores[key] *= y_o - indexes[num..].max
    indexes[num] = y_o
  end
end

b = scores.values.max


# MemoryProfiler.stop.pretty_print
helper.output(a, b)
