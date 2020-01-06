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

def neighbors(map, pos)
  [up(pos), down(pos), left(pos), right(pos)].reject { |p| map[p].nil? || map[p] == "#"  }
end

def options(map, start, keys)
  result = []
  came_from = Hash.new
  distance = Hash.new
  distance[start] = 0
  queue = [start]
  while queue.any?
    current = queue.shift
    neighbors(map, current).each do |n|
      next if came_from[n]
      char = map[n]
      unless char == "."
        if !!/[[:upper:]]/.match(char)
          next unless keys.include?(char.downcase)
        elsif !keys.include?(char)
          result << [map[n], distance[current] + 1, n]
          next
        end
      end
      came_from[n] = current
      distance[n] = distance[current] + 1
      queue << n
    end
  end
  result.select { |c| !!/[[:lower:]]/.match(c.first) }
end

def minimum_steps(memo, map, start, keys)
  keystring = keys.join
  return memo[[start, keystring]] if memo[[start, keystring]]
  opts = options(map, start, keys)
  if opts.length == 0
    memo[[start, keystring]] = 0
    return 0
  end
  distances = []
  opts.each do |key, distance, position|
    distances << distance + minimum_steps(memo, map, position, (keys + [key]).sort)
  end
  memo[[start, keystring]] = distances.min
end

input = helper.line_separated_strings('input.txt')

grid = Hash.new

input.each_with_index do |row, y|
  row.split('').each_with_index do |c, x|
    grid[[x,y]] = c
  end
end

start_pos = grid.find { |k, v| v == "@" }.first
grid[start_pos] = "."

# >5 minutes
# p minimum_steps(Hash.new, grid, start_pos, [])

# Part 2
def minimum_steps_multiple(memo, map, starts, keys)
  keystring = keys.join
  return memo[[starts, keystring]] if memo[[starts, keystring]]
  opts = starts.map { |start| options(map, start, keys) }
  if opts.map { |o| o.length }.reduce(&:+) == 0
    memo[[starts, keystring]] = 0
    return 0
  end
  distances = []
  opts.each_with_index do |bot, i|
    bot.each do |key, distance, position|
      new_starts = starts.dup
      new_starts[i] = position
      distances << distance + minimum_steps_multiple(
        memo,
        map,
        new_starts,
        (keys + [key]).sort
      )
    end
  end
  memo[[starts, keystring]] = distances.min
end

grid[up(start_pos)] = "#"
grid[down(start_pos)] = "#"
grid[left(start_pos)] = "#"
grid[right(start_pos)] = "#"
grid[start_pos] = "#"
start_pos = [
  [start_pos.first - 1, start_pos.last - 1],
  [start_pos.first + 1, start_pos.last - 1],
  [start_pos.first - 1, start_pos.last + 1],
  [start_pos.first + 1, start_pos.last + 1]
]

# current time 14+ minutes
p minimum_steps_multiple(Hash.new, grid, start_pos, [])