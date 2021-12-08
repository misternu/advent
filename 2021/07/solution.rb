require_relative '../../lib/advent_helper'
require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse
sample_input = "16,1,2,0,4,2,7,1,2,14".split(',').map(&:to_i)
# input = sample_input
# MemoryProfiler.start(allow_files: __FILE__)


# Part 1
min = input.min
max = input.max

a = (min..max).reduce(Float::INFINITY) do |m, i|
  f = input.sum { |j| (i - j).abs }
  f < m ? f : m
end

# Part 2
def fuel(n)
  (n * (n + 1)) / 2
end
b = (min..max).reduce(Float::INFINITY) do |m, i|
  f = input.sum { |j| fuel((i - j).abs) }
  f < m ? f : m
end


# MemoryProfiler.stop.pretty_print

helper.output(a, b)

