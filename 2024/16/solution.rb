require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
grid = {}
start = nil
dest = nil
input.each_with_index do |row, y|
  row.chars.each_with_index do |col, x|
    case col
    when 'S'
      start = [x, y]
    when 'E'
      dest = [x, y]
    when '#'
      grid[[x, y]] = true
    end
  end
end

DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]]

def get_options(grid, pos)
  x, y, dir, score = pos
  result = []
  # forward
  dx, dy = DIRS[dir]
  unless grid[[x + dx, y + dy]]
    result << [x + dx, y + dy, dir, score + 1]
  end
  # left
  dx, dy = DIRS[(dir - 1) % 4]
  unless grid[[x + dx, y + dy]]
    result << [x + dx, y + dy, (dir - 1) % 4, score + 1001]
  end
  # right
  dx, dy = DIRS[(dir + 1) % 4]
  unless grid[[x + dx, y + dy]]
    result << [x + dx, y + dy, (dir + 1) % 4, score + 1001]
  end
  result
end

# Part 1
scores = {}
queue = [[start[0], start[1], 1, 0]]
until queue.empty?
  pos = queue.shift
  vars = pos[0..2]
  if scores[vars].nil?
    scores[vars] = pos.last
  else
    scores[vars] = [scores[vars], pos.last].min
  end

  options = get_options(grid, pos)
  options.each do |option|
    vars = option[0..2]
    queue << option if scores[vars].nil? || option.last < scores[vars]
  end

  queue = queue.sort_by { |_, _, _, score| score }
end

keys = scores.keys.select { |x, y, _| x == dest[0] && y == dest[1] }
a = keys.map { |k| scores[k] }.min

# Part 2
def reverse_options(grid, scores, pos)
  x, y, dir, score = pos
  result = []
  dx, dy = DIRS[dir]
  ox, oy = x - dx, y - dy
  return [] if grid[[ox, oy]]
  # back
  if scores[[ox, oy, dir]] == score - 1
    result << [ox, oy, dir, score - 1]
  end
  # back left
  if scores[[ox, oy, (dir + 1) % 4]] == score - 1001
    result << [ox, oy, (dir + 1) % 4, score - 1001]
  end
  # back right
  if scores[[ox, oy, (dir - 1) % 4]] == score - 1001
    result << [ox, oy, (dir - 1) % 4, score - 1001]
  end
  result
end

key = keys.find { |k| scores[k] == a }
queue = [(key + [a])]
seen = {}
until queue.empty?
  pos = queue.shift
  seen[[pos[0], pos[1]]] = true
  options = reverse_options(grid, scores, pos)
  queue = queue + options
end

# string = (0...input.length).map do |y|
#   (0...input.first.length).map do |x|
#     pos = [x, y]
#     if grid[pos]
#       '#'
#     elsif seen[pos]
#       'O'
#     else
#       '.'
#     end
#   end.join
# end.join("\n")
# puts string

b = seen.keys.length

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
