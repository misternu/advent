require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse
# MemoryProfiler.start(allow_files: __FILE__)

# Part 1 and 2
a = 0
b = 0
input.each do |row|
  x, y, z = row.split("x").map(&:to_i).sort
  a += (3 * x * y) + (2 * y * z) + (2 * x * z)
  b += (2 * x) + (2 * y) + (x * y * z)
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
