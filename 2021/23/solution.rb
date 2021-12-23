require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
MAP = {[0, 0]=>"#", [1, 0]=>"#", [2, 0]=>"#", [3, 0]=>"#", [4, 0]=>"#", [5, 0]=>"#", [6, 0]=>"#", [7, 0]=>"#", [8, 0]=>"#", [9, 0]=>"#", [10, 0]=>"#", [11, 0]=>"#", [12, 0]=>"#", [0, 1]=>"#", [1, 1]=>".", [2, 1]=>".", [3, 1]=>".", [4, 1]=>".", [5, 1]=>".", [6, 1]=>".", [7, 1]=>".", [8, 1]=>".", [9, 1]=>".", [10, 1]=>".", [11, 1]=>".", [12, 1]=>"#", [0, 2]=>"#", [1, 2]=>"#", [2, 2]=>"#", [3, 2]=>".", [4, 2]=>"#", [5, 2]=>".", [6, 2]=>"#", [7, 2]=>".", [8, 2]=>"#", [9, 2]=>".", [10, 2]=>"#", [11, 2]=>"#", [12, 2]=>"#", [2, 3]=>"#", [3, 3]=>".", [4, 3]=>"#", [5, 3]=>".", [6, 3]=>"#", [7, 3]=>".", [8, 3]=>"#", [9, 3]=>".", [10, 3]=>"#", [2, 4]=>"#", [3, 4]=>"#", [4, 4]=>"#", [5, 4]=>"#", [6, 4]=>"#", [7, 4]=>"#", [8, 4]=>"#", [9, 4]=>"#", [10, 4]=>"#"}
positions = {
  "A" => [],
  "B" => [],
  "C" => [],
  "D" => []
}
input.each_with_index do |row, y|
  row.split('').each_with_index do |char, x|
    if ["A", "B", "C", "D"].include?(char)
      positions[char] << [x,y]
    end
  end
end


class BoardState
  attr_reader :positions, :energy_used, :locked
  def initialize(positions, energy_used = 0)
    @positions = positions
    @locked = Array.new(8, false)
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
      char_positions = @positions[i*2,2]
      destination = destinations[char]
      next unless char_positions.include?(destination.last)
      lock_index = @positions.index(destination.last)
      @locked[lock_index] = true
      next unless char_positions.include?(destination.first)
      lock_index = @positions.index(destination.first)
      @locked[lock_index] = true
    end
  end

  def can_move
    (0..7).reject do |i|
      @locked[i] ||
      (@positions[i].last == 3 && @positions.include?([@positions[i].first, 2]) )
    end
  end

  def neighbors
    result = []
    can_move.each do |i|
      if is_in_hall(i)
        path = path_to_goal(i)
        next unless path
        next unless is_clear(path)
        cost = cost_per_step(i)
        path_cost = cost * path.length
        new_positions = @positions.dup
        new_positions[i] = path.last
        result << BoardState.new(new_positions, @energy_used + path_cost)
      else
        paths = hallway_spots
          .map { |hs| path_to_hall(@positions[i], hs) }
          .select { |path| is_clear(path) } 
        cost = cost_per_step(i)
        paths.each do |path|
          path_cost = cost * path.length
          new_positions = @positions.dup
          new_positions[i] = path.last
          result << BoardState.new(new_positions, @energy_used + path_cost)
        end
      end
    end
    result
  end

  def is_in_hall(i)
    @positions[i].last == 1
  end

  def cost_per_step(i)
    j = i / 2
    case j
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
    path = current.last == 3 ? [[current.first, 2]] : []
    if destination.first > current.first
      path + (current.first..destination.first).map { |i| [i, 1] }
    else
      path + (destination.first..current.first).to_a.reverse.map { |i| [i, 1] }
    end
  end

  def path_to_goal(i)
    current = @positions[i]
    char = char_from_index(i)
    goal = destinations[char]
    return false if @positions.include?(goal.last) && char_from_index(@positions.index(goal.last)) != char
    destination = @positions.include?(goal.last) ? goal.first : goal.last
    if current.first < destination.first
      path = (current.first+1..destination.first).map { |i| [i, 1] } + [[destination.first, 2]]
    else
      path = (destination.first..current.first-1).to_a.reverse.map { |i| [i, 1] } + [[destination.first, 2]]
    end
    destination.last == 3 ? path + [destination] : path
  end

  def is_clear(path)
    path.none? { |p| @positions.include?(p) }
  end

  def destinations
    {
      "A" => [[3,2], [3,3]],
      "B" => [[5,2], [5,3]],
      "C" => [[7,2], [7,3]],
      "D" => [[9,2], [9,3]]
    }
  end

  def char_from_index(i)
    ["A", "B", "C", "D"][i/2]
  end

  def hallway_spots
    [[1,1],[2,1],[4,1],[6,1],[8,1],[10,1],[11,1]]
    # [[2,1],[4,1],[6,1],[8,1],[10,1]]
  end

  def pretty_print
    lines = (0..4).map do |y|
      (0..14).map do |x|
        if @positions.include?([x,y])
          ["A", "B", "C", "D"][@positions.index([x,y]) / 2]
        elsif MAP.include?([x,y])
          MAP[[x,y]]
        else
          " "
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
state = BoardState.new(positions.values_at("A","B","C","D").flatten(1))
queue = [state]
seen = {}
best = nil
until queue.empty?
  current = queue.shift
  if seen.has_key?(current.positions)
    next unless seen[current.positions] == current.energy_used
  end
  system 'clear'
  puts current.pretty_print
  puts best&.energy_used
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
  neighbors = current.neighbors.reject { |n| seen.has_key?(n.positions) && seen[n.positions] <= n.energy_used }
  neighbors.each { |n| seen[n.positions] = n.energy_used }
  queue = queue + neighbors
  queue = queue.sort_by { |p| [p.locked.count(false), p.energy_used] }
end
puts best.pretty_print
# state = BoardState.new([[3,3], [10,1], [5,2], [5,3], [7,2], [7,3], [9,2], [9,3]])
# puts state.pretty_print
# p state.positions
# state.neighbors.each do |n|
#   puts n.pretty_print
#   p n.locked
# end
a = best.energy_used

# Part 2
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
