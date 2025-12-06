require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
ADD = '+'.freeze
SPACE = ' '.freeze

# Part 1
a_input = input.dup.map do |line|
  line.split(/\s+/).reject(&:empty?)
end
a = 0
a_input.transpose.each do |prob|
  op = prob.pop
  nums = prob.map(&:to_i)
  a += op == ADD ? nums.reduce(:+) : nums.reduce(:*)
end

# Part 2
spaces = [-1]
(0...input.first.length).each do |i|
  spaces << i if input.all? { |l| l[i] == SPACE }
end
spaces << input.first.length

b = 0

(0...spaces.length - 1).each do |i|
  prob = input.map { |l| l[spaces[i] + 1...spaces[i + 1]] }
  op = prob.pop.strip
  nums = prob.map(&:chars).transpose.map(&:join).map(&:to_i)
  b += op == ADD ? nums.reduce(:+) : nums.reduce(:*)
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
