require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
# input = helper.auto_parse
sample_input = helper.line_separated_strings('sample_input.txt')
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
row_count = input.length
col_count = input[0].length
obstacles = {}
input_pos = nil

input.each_with_index do |row, y|
  row.split('').each_with_index do |col, x|
    if col == "^"
      input_pos = [x, y]
    elsif col == "#"
      obstacles[[x, y]] = true
    end
  end
end

dir = 0
pos = input_pos.dup
DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze
visited = {}

while pos[0] >= 0 && pos[1] >= 0 && pos[0] < col_count && pos[1] < row_count
  new_pos = [pos[0] + DIRS[dir][0], pos[1] + DIRS[dir][1]]
  if obstacles[new_pos]
    dir = (dir + 1) % 4
  else
    visited[pos] = true
    pos = new_pos
  end
end

a = visited.keys.count

# Part 2

b = 0

visited.each_key do |obst|
  next if obstacles[obst]
  next if input_pos == obst

  pos = input_pos.dup
  dir = 0
  visited = {}
  while pos[0] >= 0 && pos[1] >= 0 && pos[0] < col_count && pos[1] < row_count
    if visited[(pos + [dir])]
      b += 1
      break
    end
    new_pos = [pos[0] + DIRS[dir][0], pos[1] + DIRS[dir][1]]
    if new_pos == obst || obstacles[new_pos]
      dir = (dir + 1) % 4
    else
      visited[(pos + [dir])] = true
      pos = new_pos
    end
  end
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
