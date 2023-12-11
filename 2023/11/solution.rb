require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
expand_rows = []
expand_cols = []

input.each_with_index do |row, y|
  if row.chars.count("#") == 0
    expand_rows << y
  end
end

input.map(&:chars).transpose.each_with_index do |col, x|
  if col.count("#") == 0
    expand_cols << x
  end
end

map = {}

input.each_with_index do |row, y|
  y_offset = expand_rows.count { |v| v < y }
  row.chars.each_with_index do |ch, x|
    next unless ch == "#"
    x_offset = expand_cols.count { |v| v < x }
    map[[x + x_offset, y + y_offset]] = true
  end
end

def manhattan(j, k)
  x_j, y_j = j
  x_k, y_k = k

  (y_k - y_j).abs + (x_j - x_k).abs
end

a = map.keys.combination(2).sum do |j, k|
  manhattan(j, k)
end

# Part 2
big_rows = []
big_cols = []

input.each_with_index do |row, y|
  if row.chars.count("#") == 0
    big_rows << y
  end
end

input.map(&:chars).transpose.each_with_index do |col, x|
  if col.count("#") == 0
    big_cols << x
  end
end

big_map = {}

input.each_with_index do |row, y|
  y_offset = big_rows.count { |v| v < y } * (1000000 - 1)
  row.chars.each_with_index do |ch, x|
    next unless ch == "#"
    x_offset = big_cols.count { |v| v < x } * (1000000 - 1)
    big_map[[x + x_offset, y + y_offset]] = true
  end
end

b = big_map.keys.combination(2).sum do |j, k|
  manhattan(j, k)
end



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
