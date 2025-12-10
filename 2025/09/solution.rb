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
input = input.map { |l| l.map(&:to_i) }

def area(tile1, tile2)
  width = (tile1[0] - tile2[0]).abs + 1
  height = (tile1[1] - tile2[1]).abs + 1
  width * height
end

a = input.combination(2).reduce(0) do |max, pair|
  val = area(*pair)
  val > max ? val : max
end

# Part 2
b = nil

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
