require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
input = input.split("\n\n")

# parts = input[0...6]
# sizes = parts.map { |part| part.chars.count('#') }
lines = input.last.split("\n").map { |l| l.split(/\D+/).map(&:to_i) }

a = lines.count do |line|
  n, m, *counts = line
  # total = counts.each.with_index { |c, i| total += c * sizes[i] }
  n * m > counts.reduce(&:+) * 7
end

# Part 2
b = nil

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
