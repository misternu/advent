require_relative 'priority_queue'

def find(maze, char)
  maze.each_with_index do |row, row_index|
    row.each_with_index do |col, col_index|
      return [col_index, row_index] if col == char
    end
  end
  nil
end

def find_nums(maze)
  ("1".."9").map do |num|
    find(maze, num)
  end .compact
end

def is_wall(maze, pos)
  x, y = pos
  maze[y][x] == '#'
end

def neighbors(maze, pos, cost_so_far)
  [[-1,0], [0,1], [1,0], [0,-1]].map do |direction|
    [pos[0] + direction[0], pos[1] + direction[1]]
  end
  .reject { |neighbor| cost_so_far[neighbor] || is_wall(maze, neighbor) }
end

def heuristic(pos, dest)
  (dest[0]-pos[0]).abs + (dest[1]-pos[1]).abs
end

def extend_frontier(maze, pos, frontier, cost_so_far, came_from, dest)
  new_cost = cost_so_far[pos] + 1
  neighbors(maze, pos, cost_so_far).each do |neighbor|
    frontier.add(neighbor, new_cost + heuristic(neighbor, dest))
    cost_so_far[neighbor] = new_cost
    came_from[neighbor] = pos
  end
end

# Part 1
maze = File.open('input.txt').readlines.map do |row|
  row.strip.split('')
end

zero = find(maze, "0")
dests = find_nums(maze)
places = [zero] + dests
trip_costs = {}

places.combination(2).each do |comb|
  frontier = PriorityQueue.new
  start = comb[0]
  destination = comb[1]
  frontier.add(start, 0)
  cost_so_far = {start => 0}
  came_from = {start => nil}
  until frontier.empty?
    pos = frontier.pull
    break if pos == destination
    extend_frontier(maze,
                    pos,
                    frontier,
                    cost_so_far,
                    came_from,
                    destination)
  end
  trip_costs[comb.sort] = cost_so_far[destination]
end


routes = dests.permutation.to_a.map do |perm|
  [zero] + perm + [zero]
end
costs = routes.map do |route|
  trips = (0..route.length-2).map do |i|
    trip_costs[[route[i], route[i+1]].sort]
  end
  trips.reduce(&:+)
end

p costs.min
