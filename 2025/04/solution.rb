require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
height = input.length
width = input.first.length
ROLL = '@'.freeze

def neighbor_pos(point, width, height)
  x, y = point
  [
    [y - 1, x - 1], [y - 1, x], [y - 1, x + 1],
    [y, x - 1], [y, x + 1],
    [y + 1, x - 1], [y + 1, x], [y + 1, x + 1]
  ].select do |dy, dx|
    dx >= 0 && dy >= 0 && dx < width && dy < height
  end
end

# Part 1
a = 0
(0...height).each do |y|
  (0...width).each do |x|
    next unless input[y][x] == ROLL

    count = neighbor_pos([x, y], width, height).count { |dy, dx| input[dy][dx] == ROLL }
    a += 1 if count < 4
  end
end

# Part 2

grid = {}
(0...height).each do |y|
  (0...width).each do |x|
    grid[[x, y]] = true if input[y][x] == ROLL
  end
end

b = 0
trying = true
while trying
  run = []
  (0...height).each do |y|
    (0...width).each do |x|
      next unless grid[[x, y]]

      count = neighbor_pos([x, y], width, height).count { |dy, dx| grid[[dx, dy]] }
      next if count >= 4

      run << [x, y]
      b += 1
    end
  end

  trying = run.length.positive?
  run.each do |pos|
    grid.delete(pos)
  end
end
# MemoryProfiler.stop.pretty_print
helper.output(a, b)
