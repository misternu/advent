require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = sample_input

# Part 1
input = input.map { |l| l.split('') }
HEIGHT = input.length
WIDTH = input.first.length
map = {}
start = nil
input.each_with_index do |row, y|
  row.each_with_index do |ch, x|
    if ch == "#"
      map[[x,y]] = true
    end
    if ch == "S"
      start = [x,y]
    end
  end
end

def neighbors(map, path, pos)
  x, y = pos
  results = []
  [[0,-1], [1,0], [0,1], [-1,0]].map do |dx, dy|
    nx = x + dx
    ny = y + dy
    next if nx < 0
    next if ny < 0
    next if nx >= WIDTH
    next if ny >= HEIGHT
    new_pos = [x+dx, y+dy]
    next if map[new_pos]
    next if path[new_pos]
    results << new_pos
  end
  results
end

path = { start => 0 }
queue = [start]
depth = 64
until queue.empty?
  h = queue.shift
  next if path[h] >= depth
  ns = neighbors(map, path, h)
  ns.each do |n|
    path[n] = path[h] + 1
  end
  queue = (queue + ns).uniq
end

# (0...HEIGHT).each do |y|
#   line = (0...WIDTH).map do |x|
#     if map[[x,y]]
#       '#'
#     elsif path[[x,y]] && path[[x,y]] % 2 == 0
#       'O'
#     else
#       '.'
#     end
#   end
#   puts line.join
# end

a = path.count { |k,v| v % 2 == 0 }

# Part 2

def neighbors_two(map, path, pos)
  x, y = pos
  results = []
  [[0,-1], [1,0], [0,1], [-1,0]].map do |dx, dy|
    nx = x + dx
    ny = y + dy
    next if map[[nx % WIDTH, ny % HEIGHT]]
    new_pos = [nx, ny]
    next if path[new_pos]
    results << new_pos
  end
  results
end

path = { start => 0 }
queue = [start]
depth = 500
until queue.empty?
  h = queue.shift
  next if path[h] >= depth
  ns = neighbors_two(map, path, h)
  ns.each do |n|
    path[n] = path[h] + 1
  end
  queue = (queue + ns).uniq
end


b = path.count { |k,v| v % 2 == 0 }



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
