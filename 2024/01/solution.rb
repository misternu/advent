require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
pairs = input.dup.map { |line| line.map(&:to_i) }
left, right = pairs.transpose
left_sorted, right_sorted = left.sort, right.sort

a = 0

(0...(left.length)).each do |i|
  a += (left_sorted[i] - right_sorted[i]).abs
end

# Part 2
b = 0

(0...(left.length)).each do |i|
  b += right.count(left[i]) * left[i]
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
