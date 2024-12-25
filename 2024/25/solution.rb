require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
input = input.split("\n\n")

locks = []
keys = []

input.each do |string|
  lines = string.split("\n")
  if lines[0].chars.all? { |c| c == '.' }
    keys << lines.map { |l| l.split('') }.transpose.map { |l| l.count('#') - 1 }
  else
    locks << lines.map { |l| l.split('') }.transpose.map { |l| l.count('#') - 1 }
  end
end

# Part 1
a = locks.product(keys).count do |lock, key|
  lock.zip(key).map(&:sum).all? { |c| c < 6 }
end

b = nil

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
