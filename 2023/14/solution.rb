require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.send(:open_file, 'sample_input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
rocks = {}
cubes = {}
input.each_with_index do |row, y|
  row.chars.each_with_index do |ch, x|
    if ch == "O"
      rocks[[x,y]] = true
    elsif ch == "#"
      cubes[[x,y]] = true
    end
  end
end

(0...input.length).each do |y|
  (0...input.first.length).each do |x|
    next unless rocks[[x,y]]
    dx, dy = x, y

    until dy == 0 || cubes[[dx, dy-1]] || rocks[[dx, dy-1]]
      dy -= 1
    end
    rocks.delete([x,y])
    rocks[[dx,dy]] = true
  end
end



a = rocks.keys.sum do |k|
  input.length - k.last
end

# Part 2
# NWSE
DIRS = [[0, -1], [-1, 0], [0, 1], [1, 0]]
HEIGHT = input.length
WIDTH = input.first.length
rocks = {}
cubes = {}
input.each_with_index do |row, y|
  row.chars.each_with_index do |ch, x|
    if ch == "O"
      rocks[[x,y]] = true
    elsif ch == "#"
      cubes[[x,y]] = true
    end
  end
end

def cycle!(rock_map, cube_map)
  DIRS.each do |dir|
    moved = false
    while true
      keys = rock_map.keys
      keys.each do |k|
        dx, dy = k
        dist = 0
        until (dx + dir[0] < 0 || dy + dir[1] < 0) ||
          (dx + dir[0] == WIDTH || dy + dir[1] == HEIGHT) ||
          cube_map[[dx + dir[0], dy + dir[1]]] ||
          rock_map[[dx + dir[0], dy + dir[1]]]
          dx, dy = dx + dir[0], dy + dir[1]
          dist += 1
        end
        if dist > 0
          moved = true
          rock_map.delete(k)
          rock_map[[dx,dy]] = true
        end
      end

      break unless moved
      moved = false
    end
  end
end

seen = {}
cycle_num = 1
loop_length = nil
while true
  cycle!(rocks, cubes)
  if seen[rocks.keys.sort]
    loop_length = cycle_num - seen[rocks.keys.sort]
    break
  else
    seen[rocks.keys.sort] = cycle_num
    cycle_num += 1
  end
end

cycles_ago = loop_length - ((1000000000 - cycle_num) % loop_length)

cycled_rocks = seen.key(cycle_num - cycles_ago)
weight = cycled_rocks.sum do |k|
  HEIGHT - k.last
end

b = weight
# MemoryProfiler.stop.pretty_print
helper.output(a, b)


# (0...input.length).each do |y|
#   line = (0...input.first.length).map do |x|
#     if rocks[[x,y]]
#       "O"
#     elsif cubes[[x,y]]
#       "#"
#     else
#       "."
#     end
#   end .join

#   puts line
# end
