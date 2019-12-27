require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

def    up(pos); [pos[0], pos[1] + 1] end
def right(pos); [pos[0] + 1, pos[1]] end
def  down(pos); [pos[0], pos[1] - 1] end
def  left(pos); [pos[0] - 1, pos[1]] end

class PriorityQueue
  def initialize
    @items = []
  end

  def add(priority, item)
    @items << [priority, item]
  end

  def any?
    @items.any?
  end

  def length
    @items.length
  end

  def next
    sort
    @items.shift.last
  end

  def sort
    @items.sort_by! { |i| i.first }
  end
end

class AStar
  def initialize(map, goal, origin = [0, 0])
    @map = map
    @queue = PriorityQueue.new
    @goal = goal
    @origin = origin
  end

  def path
    @queue.add(0, @origin)
    came_from = Hash.new
    cost_so_far = Hash.new
    cost_so_far[@origin] = 0
    while @queue.any?
      current = @queue.next
      break if current == @goal
      neighbors(current).each do |n|
        new_cost = cost_so_far[current] + 1
        if !cost_so_far[n] || new_cost < cost_so_far[n]
          cost_so_far[n] = new_cost
          priority = new_cost + manhattan(n)
          @queue.add(priority, n)
          came_from[n] = current
        end
      end
    end
    if came_from[@goal]
      current = @goal
      path = []
      while current
        path << current
        current = came_from[current]
      end
      return path.reverse
    end
    nil
  end

  def manhattan(pos)
    (@origin.first - pos.first).abs + (@origin.last - pos.last).abs
  end

  def neighbors(pos)
    [up(pos), down(pos), left(pos), right(pos)].select { |p| p == @goal || @map[p] == "." }
  end
end

def neighbors(map, pos)
  [up(pos), down(pos), left(pos), right(pos)].reject { |p| map[p].nil? || map[p] == "#"  }
end

def options(map, start, keys = [])
  result = []
  came_from = Hash.new
  queue = [start]
  while queue.any?
    current = queue.shift
    neighbors(map, current).each do |n|
      next if came_from[n]
      if map[n] == "."
        came_from[n] = current
        queue << n
      else
        result << map[n]
      end
    end
  end
  result.select { |c| !!/[[:lower:]]/.match(c) }
end

input = helper.line_separated_strings('input.txt')

# input = [
#   "########################",
#   "#...............b.C.D.f#",
#   "#.######################",
#   "#.....@.a.B.c.d.A.e.F.g#",
#   "########################"
# ]

grid = Hash.new

input.each_with_index do |row, y|
  row.split('').each_with_index do |c, x|
    grid[[x,y]] = c
  end
end

keys = grid.select { |k, v| !!/[[:lower:]]/.match(v) }
keys_len = keys.length
doors = grid.select { |k, v| !!/[[:upper:]]/.match(v) }
start_pos = grid.find { |k, v| v == "@" }.first
grid[start_pos] = "."

# Part 1
# { map: map, pos: pos, steps: x, keys:["a", "b"] }

shortest_so_far = Float::INFINITY
queue = PriorityQueue.new
queue.add(0, {map: grid.dup, pos: start_pos, steps: 0, keys: []})
while queue.any?
  p queue.length
  current = queue.next
  if current[:keys].length == keys_len
    p "FOUND"
    p shortest_so_far = [shortest_so_far, current[:steps]].min
    next
  end
  if current[:steps] > shortest_so_far
    next
  end
  options(current[:map], current[:pos]).each do |option|
    new_pos = keys.key(option)
    astar = AStar.new(current[:map], new_pos, current[:pos])
    steps = astar.path.length - 1
    new_map = current[:map].dup
    new_map[new_pos] = "."
    new_map[doors.key(option.capitalize)] = "."
    new_state = {
      map: new_map,
      pos: new_pos,
      steps: current[:steps] + steps,
      keys: current[:keys] + [option]
    }
    queue.add([keys_len - new_state[:keys].length, new_state[:steps]], new_state)
  end
end
p shortest_so_far

# paths:

# Part 2
input
