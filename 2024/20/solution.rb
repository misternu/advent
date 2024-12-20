require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
WIDTH = input.first.length.freeze
HEIGHT = input.length.freeze
grid = {}
start = nil
out = nil
input.each_with_index do |row, y|
  row.split('').each_with_index do |col, x|
    if col == '#'
      grid[[x, y]] = true
    elsif col == 'S'
      start = [x, y]
    elsif col == 'E'
      out = [x, y]
    end
  end
end

DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze

def neighbors(grid, pos)
  x, y = pos
  DIRS.map { |dx, dy| [x + dx, y + dy] }.reject { |cx, cy| grid[[cx, cy]] }
end

def cheat_neighbors(grid, pos)
  x, y = pos
  blocked_dirs = DIRS.select { |dx, dy| grid[[x + dx, y + dy]] }
  cheated_dirs = blocked_dirs.map { |dx, dy| [x + (2 * dx), y + (2 * dy)] }
  cheated_dirs.select do |cx, cy|
    grid[[cx, cy]].nil? &&
      cx >= 0 &&
      cx < WIDTH &&
      cy >= 0 &&
      cy < HEIGHT
  end
end

# Part 1

queue = [[out + [nil], 0]]
visited = {}

until queue.empty?
  pos, steps = queue.shift
  visited[pos] = steps

  neighbors(grid, pos).each do |neighbor|
    next if visited[neighbor]
    queue << [neighbor, steps + 1]
  end

  queue.sort_by { |n, s| s }
end

a = 0
visited.keys.each do |pos|
  cheat_neighbors(grid, pos).each do |neighbor|
    a += 1 if visited[pos] - visited[neighbor] - 2 >= 100
  end
end

# Part 2
b = 0
visited.keys.each do |pos|
  x, y = pos

  ((y - 20)..(y + 20)).each do |cy|
    next if cy < 0
    next if cy >= HEIGHT
    ((x - 20)..(x + 20)).each do |cx|
      next if cx < 0
      next if cx >= WIDTH
      next unless visited[[cx, cy]]
      manhattan = (x - cx).abs + (y - cy).abs
      next if manhattan > 20
      savings = visited[pos] - visited[[cx, cy]] - manhattan
      b += 1 if savings >= 100
    end
  end
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
