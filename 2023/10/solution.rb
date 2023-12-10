require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
PIPES = {
  '|' => [1, 0, 1, 0],
  '-' => [0, 1, 0, 1],
  'L' => [1, 1, 0, 0],
  'J' => [1, 0, 0, 1],
  '7' => [0, 0, 1, 1],
  'F' => [0, 1, 1, 0]
}
animal_y = input.index { |r| r.split('').include?("S") }
animal_x = input[animal_y].index("S")
pos = [animal_x, animal_y]

def neighbors(map, pos)
  x, y = pos
  result = []
  pos_ch = map[y][x]
  if pos_ch == "S"
    dirs = [1,1,1,1]
  else
    dirs = PIPES[pos_ch]
  end
  # n
  if y > 0 && dirs[0] == 1
    ch = map[y-1][x]
    if PIPES[ch] && PIPES[ch][2] == 1
      result << [x, y-1]
    end
  end
  # e
  if x < (map.first.length-1) && dirs[1] == 1
    ch = map[y][x+1]
    if PIPES[ch] && PIPES[ch][3] == 1
      result << [x+1, y]
    end
  end
  # s
  if y < (map.length-1) && dirs[2] == 1
    ch = map[y+1][x]
    if PIPES[ch] && PIPES[ch][0] == 1
      result << [x, y+1]
    end
  end
  # w
  if x > 0 && dirs[3] == 1
    ch = map[y][x-1]
    if PIPES[ch] && PIPES[ch][1] == 1
      result << [x-1, y]
    end
  end
  result
end

queue = [pos]
path = { pos => 0}

until queue.empty?
  point = queue.shift
  ns = neighbors(input, point)
  ns.each do |neighbor|
    next if path[neighbor]
    path[neighbor] = path[point] + 1
    queue << neighbor
  end
end

a = path.values.max

# Part 2

# manually fill map
input.each do |row|
  if row.chars.include?("S")
    row.gsub!("S", "F")
  end
end

count = 0
inside_map = {}

input.each_with_index do |row, y|
  inside = [0,0]
  row.chars.each_with_index do |ch, x|
    if path[[x, y]]
      case ch
      when '|'
        inside = [(inside[0] + 1) % 2, (inside[1] + 1) % 2]
      when 'L'
        inside[0] = inside[0] == 1 ? 0 : 1
      when 'J'
        inside[0] = inside[0] == 1 ? 0 : 1
      when '7'
        inside[1] = inside[1] == 1 ? 0 : 1
      when 'F'
        inside[1] = inside[1] == 1 ? 0 : 1
      end
    elsif inside == [1,1]
      count += 1
      inside_map[[x,y]] = true
    end
  end
end

# print map:
# y1 = path.keys.map(&:last).min
# y2 = path.keys.map(&:last).max
# x1 = path.keys.map(&:first).min
# x2 = path.keys.map(&:first).max
# (y1..y2).each do |y|
#   row = input[y][x1..x2]
#   line = row.chars.each_with_index.map do |ch, dx|
#     path[[x1+dx, y]] ? "#" : ch
#   end
#   puts line.join
# end

b = count



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
