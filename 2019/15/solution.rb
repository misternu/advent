require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

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
    [up(pos), down(pos), left(pos), right(pos)].select { |p| p == @goal || @map[p] == 1 }
  end
end

def explore(input, path)
  computer = IntcodeComputer.new(input, IntcodeIO.new())
  pos = path.first
  last_result = nil
  path[1..-1].each do |step|
    direction = [up(pos), down(pos), left(pos), right(pos)].index(step) + 1
    computer.io.add(direction)
    computer.resume
    last_result = computer.io.shift
    pos = step
  end
  last_result
end

def neighbors(map, pos)
  [up(pos), down(pos), left(pos), right(pos)].reject { |p| map[p] }
end

def manhattan_a_b(a, b)
  (b.first - a.first).abs + (b.last - a.last).abs
end

def print_map(map, origin = [0, 0], size = 25)
  print "\e[H"
  (origin.last + size).downto(origin.last - size).each do |y|
    puts ((origin.first - size)..(origin.first + size)).map { |x|
      map[[x, y]] == 0 ? "#" : map[[x, y]] == 1 ? "." : map[[x, y]] == 2 ? "0" : " "
    }.join
  end
end

input = helper.comma_separated_strings('input.txt').map(&:to_i)

map = Hash.new
queue = PriorityQueue.new

queue.add(0, [0, 0])
map[[0,0]] = 1

puts `clear`
while queue.any?
  current = queue.next
  neighbors(map, current).each do |pos|
    astar = AStar.new(map, pos)
    path = astar.path
    if path
      map[pos] = explore(input, path)
      queue.add(path.length + manhattan_a_b([0, 0], pos), pos)
    end
  end
  print_map(map)
end

goal = map.find { |k, v| v == 2 } 
part1 = AStar.new(map, goal.first).path.length - 1

count = 0
while map.values.include?(1)
  map.select { |k, v| v == 2 }.each do |pos, v|
    [up(pos), down(pos), left(pos), right(pos)].each do |n|
      if map[n] == 1
        map[n] = 2
      end
    end
  end
  print_map(map)
  count += 1
end

p part1
p count