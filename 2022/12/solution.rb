require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

input.map!(&:chars)

start_pos = nil
end_pos = nil
elevations = input.each_with_index.map do |row, y|
  row.each_with_index.map do |col, x|
    if col == "S"
      start_pos = [x,y]
      1
    elsif col == "E"
      end_pos = [x,y]
      26
    else
      col.ord - 96
    end
  end
end
# elevations.each do |row|
#   p row
# end

DIRS = [
  [0, -1],
  [1, 0],
  [0, 1],
  [-1, 0]
]

class PriorityQueue
  def initialize
    @queue = {}
  end

  def add(element, priority)
    @queue[element] = priority
  end

  def pull
    top = @queue.min_by { |k,v| v } .first
    @queue.delete(top)
    top
  end

  def empty?
    @queue.empty?
  end
end

def neighbors(pos, elevations)
  n = []
  current_elevation = elevations[pos[1]][pos[0]]
  DIRS.each do |dir|
    new_pos = pos.zip(dir).map(&:sum)
    next unless (0...elevations.first.length).member?(new_pos[0])
    next unless (0...elevations.length).member?(new_pos[1])
    new_elevation = elevations[new_pos[1]][new_pos[0]]
    next unless new_elevation <= current_elevation + 1
    n << new_pos
  end
  n
end

came_from = {}
cost_so_far = { start_pos => 0 }
queue = PriorityQueue.new
queue.add(start_pos, 0)

until queue.empty?
  current = queue.pull
  break if current == end_pos

  n = neighbors(current, elevations)
  n.each do |neighbor|
    new_cost = cost_so_far[current] + 1
    next if cost_so_far[neighbor] && cost_so_far[neighbor] <= new_cost
    cost_so_far[neighbor] = new_cost
    queue.add(neighbor, new_cost)
    came_from[neighbor] = current
  end
end

path_length = 0
pos = end_pos
while came_from[pos]
  pos = came_from[pos]
  path_length += 1
end


# Part 1
a = path_length

# Part 2
def neighbors(pos, elevations)
  n = []
  current_elevation = elevations[pos[1]][pos[0]]
  DIRS.each do |dir|
    new_pos = pos.zip(dir).map(&:sum)
    next unless (0...elevations.first.length).member?(new_pos[0])
    next unless (0...elevations.length).member?(new_pos[1])
    new_elevation = elevations[new_pos[1]][new_pos[0]]
    next unless new_elevation > (current_elevation - 2)
    n << new_pos
  end
  n
end

came_from = {}
cost_so_far = { end_pos => 0 }
queue = PriorityQueue.new
queue.add(end_pos, 0)
low_point = nil
until queue.empty?
  current = queue.pull
  current_elevation = elevations[current[1]][current[0]]
  if current_elevation == 1
    low_point = current
    break
  end

  n = neighbors(current, elevations)
  n.each do |neighbor|
    new_cost = cost_so_far[current] + 1
    next if cost_so_far[neighbor] && cost_so_far[neighbor] <= new_cost
    cost_so_far[neighbor] = new_cost
    queue.add(neighbor, new_cost)
    came_from[neighbor] = current
  end
end
path_length = 0
pos = low_point
while came_from[pos]
  pos = came_from[pos]
  path_length += 1
end
b = path_length



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
