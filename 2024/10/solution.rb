require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
height = input.length
width = input.first.length

# Part 1
grid = {}
input.each_with_index do |row, y|
  row.split('').each_with_index do |col, x|
    grid[[x, y]] = col.to_i
  end
end

def neighbor_pos(point, width, height)
  x, y = point
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select do |x, y|
    x >= 0 && y >= 0 && x < width && y < height
  end
end

a = 0
(0...height).each do |y|
  (0...width).each do |x|
    next unless grid[[x, y]].zero?

    queue = [[x, y]]
    visited = {}

    until queue.empty?
      point = queue.shift
      next if visited[point]

      val = grid[point]
      visited[point] = true
      if val == 9
        a += 1
        next
      end
      neighbor_pos(point, width, height).each do |n|
        queue << n if grid[n] == val + 1
      end
    end
  end
end

# Part 2
b = 0
(0...height).each do |y|
  (0...width).each do |x|
    next unless grid[[x, y]].zero?

    queue = [[[x, y]]]
    until queue.empty?
      path = queue.shift
      val = grid[path.last]
      if val == 9
        b += 1
        next
      end
      neighbor_pos(path.last, width, height).each do |n|
        next unless grid[n] == val + 1

        new_path = path.dup
        new_path << n
        queue << new_path
      end
    end
  end
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
