require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input

# Part 2
neighbors = Hash.new { |h, k| h[k] = [] }
input.each do |line|
  a, b = line.split('-').map(&:to_sym)
  if b != :start && a != :end
    neighbors[a] << b
  end
  if a != :start && b != :end
    neighbors[b] << a
  end
end

LOWER = /[[:lower:]]/

def can_go(path, pos)
  path[pos] == 0 || !path.has_value?(2)
end

count = 0
start_path = Hash.new(0)
start_path[:pos] = :start
paths = [start_path]
until paths.empty?
  path = paths.shift
  count += 1 if path[:pos] == :end
  neighbors[path[:pos]].each do |choice|
    next unless can_go(path, choice)
    new_path = path.dup
    new_path[:pos] = choice
    if LOWER.match?(choice)
      new_path[choice] += 1
    end
    paths << new_path
  end
end
b = count


# MemoryProfiler.stop.pretty_print
helper.output(nil, b)
