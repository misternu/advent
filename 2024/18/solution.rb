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

input = input.map { |l| l.map(&:to_i) }

grid = {}
count = 1024
width = 71
height = 71
out = [width - 1, height - 1]

input[0...count].each do |pos|
  grid[pos] = true
end

DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze

# Part 1
queue = [[0, 0, 0]]
from = {}

def neighbors(grid, width, height, pos)
  x, y, steps = pos
  result = DIRS.map { |dx, dy| [x + dx, y + dy, steps + 1] }
  result.select do |nx, ny, _|
    !grid[[nx, ny]] && nx >= 0 && nx < width && ny >= 0 && ny < height
  end
end

until queue.empty?
  pos = queue.shift

  neighbors(grid, width, height, pos).each do |n_pos|
    xy = n_pos[0..1]
    next if from[xy]
    from[xy] = pos[0..1]
    queue << n_pos
  end

  queue.sort_by do |x, y, steps|
    [(x - out[0]).abs + (y - out[1]).abs, steps]
  end
end

a = 0

pos = out
while pos != [0, 0]
  pos = from[pos]
  a += 1
end

# Part 2

b = nil

input[count..].each do |byte|
  grid[byte] = true

  queue = [[0, 0, 0]]
  from = {}

  until queue.empty?
    pos = queue.shift
    neighbors(grid, width, height, pos).each do |n_pos|
      xy = n_pos[0..1]
      next if from[xy]
      from[xy] = pos[0..1]
      queue << n_pos
    end
    break if from[out]
  end

  unless from[out]
    b = byte
    break
  end

  queue.sort_by do |x, y, steps|
    [(x - out[0]).abs + (y - out[1]).abs, steps]
  end
end

b = b.join(",")

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
