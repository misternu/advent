require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input

neighbors = Hash.new { |h, k| h[k] = [] }
input.each do |line|
  a, b = line.split('-').map(&:to_sym)
  neighbors[a] << b
  neighbors[b] << a
end
UPPER = /[[:upper:]]/
LOWER = /[[:lower:]]/
# Part 2
def can_go(path, pos)
  return false if pos == :start
  return true if pos == :end
  return true if path[pos] == 0
  return true unless path.has_value?(2)
  false
end
count = 0
start_path = Hash.new(0)
start_path[:pos] = :start
paths = [start_path]
until paths.empty?
  path = paths.shift
  if path[:pos] == :end
    count += 1
    next
  end
  neighbors[path[:pos]].each do |choice|
    next unless can_go(path, choice)
    new_path = path.dup
    new_path[:pos] = choice
    if LOWER =~ choice
      new_path[choice] += 1
    end
    paths << new_path
  end
end
b = count


# MemoryProfiler.stop.pretty_print
helper.output(nil, b)
