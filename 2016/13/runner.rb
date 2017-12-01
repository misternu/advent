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

def neighbors(pos, cost_so_far)
  [[-1,0], [0,1], [1,0], [0,-1]].map do |direction|
    [pos[0] + direction[0], pos[1] + direction[1]]
  end
  .reject { |neighbor| cost_so_far[neighbor] || is_wall(neighbor) }
end

def extend_frontier(pos, frontier, cost_so_far, came_from)
  new_cost = cost_so_far[pos] + 1
  neighbors(pos, cost_so_far).each do |neighbor|
    frontier.add(neighbor, new_cost + heuristic(neighbor))
    cost_so_far[neighbor] = new_cost
    came_from[neighbor] = pos
  end
end

INPUT = 1352
def is_wall(pos)
  x, y = pos
  return true if x < 0 || y < 0
  (x*x + 3*x + 2*x*y + y + y*y + INPUT).to_s(2).count("1") % 2 != 0
end

DESTINATION = [31,39]
def heuristic(pos)
  (DESTINATION[0]-pos[0]).abs + (DESTINATION[1]-pos[1]).abs
end

frontier = PriorityQueue.new
start = [1,1]
frontier.add(start, 0)
cost_so_far = {start => 0}
came_from = {start => nil}

until frontier.empty?
  pos = frontier.pull
  break if pos == DESTINATION
  extend_frontier(pos, frontier, cost_so_far, came_from)
end

path_length = 0
position = DESTINATION
while came_from[position]
  position = came_from[position]
  path_length += 1
end
puts path_length

# PART TWO

frontier = PriorityQueue
start = [1,1]
queue = [start]
cost_so_far = {start => 0}
came_from = {start => nil}
squares = 0
until queue.empty?
  pos = queue.shift
  moves = neighbors(pos, cost_so_far)
  moves.each do |neighbor|
    cost_so_far[neighbor] = cost_so_far[pos] + 1
    came_from[neighbor] = pos
  end
  queue += moves.reject { |neighbor| cost_so_far[neighbor] > 50 }
  squares += 1
end
puts squares