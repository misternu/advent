require_relative '../../lib/advent_helper'
require 'pqueue'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
MAP = {[0, 0]=>"#", [1, 0]=>"#", [2, 0]=>"#", [3, 0]=>"#", [4, 0]=>"#", [5, 0]=>"#", [6, 0]=>"#", [7, 0]=>"#", [8, 0]=>"#", [9, 0]=>"#", [10, 0]=>"#", [11, 0]=>"#", [12, 0]=>"#", [0, 1]=>"#", [1, 1]=>".", [2, 1]=>".", [3, 1]=>".", [4, 1]=>".", [5, 1]=>".", [6, 1]=>".", [7, 1]=>".", [8, 1]=>".", [9, 1]=>".", [10, 1]=>".", [11, 1]=>".", [12, 1]=>"#", [0, 2]=>"#", [1, 2]=>"#", [2, 2]=>"#", [3, 2]=>".", [4, 2]=>"#", [5, 2]=>".", [6, 2]=>"#", [7, 2]=>".", [8, 2]=>"#", [9, 2]=>".", [10, 2]=>"#", [11, 2]=>"#", [12, 2]=>"#", [0, 3]=>" ", [1, 3]=>" ", [2, 3]=>"#", [3, 3]=>".", [4, 3]=>"#", [5, 3]=>".", [6, 3]=>"#", [7, 3]=>".", [8, 3]=>"#", [9, 3]=>".", [10, 3]=>"#", [0, 4]=>" ", [1, 4]=>" ", [2, 4]=>"#", [3, 4]=>".", [4, 4]=>"#", [5, 4]=>".", [6, 4]=>"#", [7, 4]=>".", [8, 4]=>"#", [9, 4]=>".", [10, 4]=>"#", [0, 5]=>" ", [1, 5]=>" ", [2, 5]=>"#", [3, 5]=>".", [4, 5]=>"#", [5, 5]=>".", [6, 5]=>"#", [7, 5]=>".", [8, 5]=>"#", [9, 5]=>".", [10, 5]=>"#", [0, 6]=>" ", [1, 6]=>" ", [2, 6]=>"#", [3, 6]=>"#", [4, 6]=>"#", [5, 6]=>"#", [6, 6]=>"#", [7, 6]=>"#", [8, 6]=>"#", [9, 6]=>"#", [10, 6]=>"#"}
positions = {
  "A" => [],
  "B" => [],
  "C" => [],
  "D" => []
}
input.each_with_index do |row, y|
  row.split('').each_with_index do |char, x|
    # if char == "#"
    #   map[[x,y]] = "#"
    # elsif char == " "
    #   map[[x,y]] = " "
    # else
    #   map[[x,y]] = '.'
    # end
    if ["A", "B", "C", "D"].include?(char)
      positions[char] << [x,y]
    end
  end
end


class BoardState
  attr_reader :positions, :energy_used, :locked
  def initialize(positions, energy_used = 0)
    @positions = positions
    @locked = Array.new(16, false)
    @energy_used = energy_used 

    find_locked
  end

  def hash
    (@positions.flatten + [energy_used]).hash
  end

  def ==(other)
    other.positions == @positions &&
    other.energy_used == @energy_used
  end

  alias eql? ==

  def find_locked
    ("A".."D").each_with_index do |char, i|
      # char_positions = @positions[i*4,4]
      destination = destinations[char]
      next unless @positions.include?(destinations[char][3]) && @positions.index(destinations[char][3])/4 == i
      @locked[@positions.index(destination[3])] = true
      next unless @positions.include?(destinations[char][2]) && @positions.index(destinations[char][2])/4 == i
      @locked[@positions.index(destination[2])] = true
      next unless @positions.include?(destinations[char][1]) && @positions.index(destinations[char][1])/4 == i
      @locked[@positions.index(destination[1])] = true
      next unless @positions.include?(destinations[char][0]) && @positions.index(destinations[char][0])/4 == i
      @locked[@positions.index(destination[0])] = true
    end
  end

  def can_move
    (0..15).reject do |i|
      @locked[i] ||
      @positions.include?([positions[i].first, positions[i].last-1])
    end
  end

  def neighbors
    result = []
    can_move.each do |i|
      if is_in_hall(i)
        path = path_to_goal(i)
        next unless path
        pos, cost = path
        new_positions = @positions.dup
        new_positions[i] = pos
        result << [new_positions, @energy_used + cost]
      else
        paths = paths_to_hall(i)
        paths.each do |pos, cost|
          new_positions = @positions.dup
          new_positions[i] = pos
          result << [new_positions, @energy_used + cost]
        end
      end
    end
    result
  end

  def is_in_hall(i)
    @positions[i].last == 1
  end

  def cost_per_step(i)
    case i / 4
    when 0
      1
    when 1
      10
    when 2
      100
    when 3
      1000
    end
  end

  def path_to_hall(current, destination)
    path = (2..current.last-1).to_a.reverse.map { |y| [current.first, y] }
    if destination.first > current.first
      path + (current.first..destination.first).map { |i| [i, 1] }
    else
      path + (destination.first..current.first).to_a.reverse.map { |i| [i, 1] }
    end
  end

  def paths_to_hall(i)
    pos = @positions[i]
    column, row = pos
    left_hallway_block = hallway_spots.rindex { |spot| spot.first < column && positions.include?(spot) } || -1
    right_hallway_block = hallway_spots.index { |spot| spot.first > column && positions.include?(spot) } || 7
    step_cost = cost_per_step(i)
    hallway_spots[left_hallway_block+1..right_hallway_block-1].map do |spot|
      [spot, (row - 1 + (spot.first - column).abs) * step_cost]
    end
  end

  def path_to_goal(i)
    current = @positions[i]
    char = char_from_index(i)
    goal = destinations[char]
    return false if goal.any? { |g| @positions.include?(g) && char_from_index(@positions.index(g)) != char }
    goal_column = goal.first.first
    goal_pos = goal.reverse.find { |pos| !@positions.include?(pos) }
    return false if current.first < goal_column && (current.first+1..goal_column).any? { |x| @positions.include?([x, 1]) }
    return false if goal_column < current.first && (goal_column..current.first-1).any? { |x| @positions.include?([x, 1]) }
    step_cost = cost_per_step(i)
    cost = ((goal_column-current.first).abs + goal_pos.last - 1) * step_cost
    [goal_pos, cost]
  end

  def is_clear(path)
    path.none? { |p| @positions.include?(p) }
  end

  def destinations
    @destinations ||= {
      "A" => [[3,2], [3,3], [3,4], [3,5]],
      "B" => [[5,2], [5,3], [5,4], [5,5]],
      "C" => [[7,2], [7,3], [7,4], [7,5]],
      "D" => [[9,2], [9,3], [9,4], [9,5]],
    }.freeze
  end

  def char_from_index(i)
    ["A", "B", "C", "D"][i/4]
  end

  def hallway_spots
    [[1,1],[2,1],[4,1],[6,1],[8,1],[10,1],[11,1]]
    # [[2,1],[4,1],[6,1],[8,1],[10,1]]
  end

  def pretty_print
    lines = (0..6).map do |y|
      (0..14).map do |x|
        if @positions.include?([x,y])
          ["A", "B", "C", "D"][@positions.index([x,y]) / 4]
        else
          MAP[[x,y]] || " "
        end
      end .join
    end
    (lines + ["Energy: #{@energy_used}"]).join("\n")
  end

  def complete
    @locked.all?
  end
end


# Part 1
# state = BoardState.new(positions.values_at("A","B","C","D").flatten(1))
# queue = [state]
# seen = {}
# best = nil
# until queue.empty?
#   current = queue.shift
#   if seen.has_key?(current.positions)
#     next unless seen[current.positions] == current.energy_used
#   end
#   system 'clear'
#   puts current.pretty_print
#   puts best&.energy_used
#   if current.complete && best.nil?
#     best = current
#     next
#   end
#   if current.complete
#     best = [best, current].min_by { |s| s.energy_used }
#     next
#   end
#   if best && current.energy_used > best.energy_used
#     next
#   end
#   neighbors = current.neighbors.reject { |n| seen.has_key?(n.positions) && seen[n.positions] <= n.energy_used }
#   neighbors.each { |n| seen[n.positions] = n.energy_used }
#   queue = queue + neighbors
#   queue = queue.sort_by { |p| [p.locked.count(false), p.energy_used] }
# end
# puts best.pretty_print
# state = BoardState.new([[3,3], [10,1], [5,2], [5,3], [7,2], [7,3], [9,2], [9,3]])
# puts state.pretty_print
# p state.positions
# state.neighbors.each do |n|
#   puts n.pretty_print
#   p n.locked
# end
a = nil

# Part 2
state = BoardState.new(positions.values_at("A","B","C","D").flatten(1))
queue = PQueue.new([state]) { |a, b| a.energy_used < b.energy_used }
# queue = [state]
seen = {}
best = nil
until queue.empty?
  # current = queue.shift
  current = queue.pop
  if seen.has_key?(current.positions)
    next unless seen[current.positions] == current.energy_used
  end
  # system 'clear'
  # puts current.pretty_print
  if current.complete && best.nil?
    best = current
    next
  end
  if current.complete
    best = [best, current].min_by { |s| s.energy_used }
    next
  end
  if best && current.energy_used > best.energy_used
    next
  end
  current.neighbors.each do |positions, cost|
    next if seen.has_key?(positions) && seen[positions] <= cost
    seen[positions] = cost
    queue.push(BoardState.new(positions, cost))
  end
end
b = best.energy_used



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
