require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
SPLITTER = '^'.freeze
START = 'S'.freeze
height = input.length
width = input.first.length
splitters = {}
visited = {}
start = nil
(0...height).each do |y|
  (0...width).each do |x|
    splitters[[x, y]] = true if input[y][x] == SPLITTER
    start = [x, y] if input[y][x] == START
  end
end
beams = [start.dup]
until beams.empty?
  x, y = beams.shift
  next if y == height - 1

  if splitters[[x, y + 1]]
    unless visited[[x, y + 1]]
      beams << [x - 1, y + 1]
      beams << [x + 1, y + 1]
      visited[[x, y + 1]] = true
    end
  else
    beams << [x, y + 1]
  end
end
a = visited.keys.count

# Part 2
from = Hash.new { |h, k| h[k] = [] }
counts = Hash.new(0)
counts[start.dup] = 1
beams = [[start.dup, start.dup]]
until beams.empty?
  pos, origin = beams.shift
  x, y = pos

  if y == height - 1
    from[pos] << origin
    counts[pos] += counts[origin]
    next
  end

  if splitters[[x, y + 1]]
    if from[[x, y + 1]].empty?
      beams << [[x - 1, y + 1], [x, y + 1]]
      beams << [[x + 1, y + 1], [x, y + 1]]
    end
    from[[x, y + 1]] << origin
    counts[[x, y + 1]] += counts[origin]
  else
    beams << [[x, y + 1], origin]
  end
end

keys = from.keys.select { |_, y| y == height - 1 }
b = keys.sum { |k| counts[k] }

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
