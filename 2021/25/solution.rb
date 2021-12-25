require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = elper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
map = {}
input.each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    if char == ">" || char == "v"
      map[[x,y]] = char
    end
  end
end
height = input.length
width = input.first.length


# Part 1
def print_map(map, width, height)
  system 'clear'
  puts
  puts
  (0...height).each do |y|
    line = (0...width).map do |x|
      map[[x,y]] || "."
    end .join
    puts line
  end
  p map.keys.count
end

i = 0
while true
  moved = false
  new_map = {}
  map.select { |pos, char| char == ">" } .each do |pos, char|
    next_pos = [(pos.first + 1) % width, pos.last]
    unless map.has_key?(next_pos)
      new_map[next_pos] = char
      moved = true
    else
      new_map[pos] = char
    end
  end
  map.reject { |pos, char| char == ">" } .each do |pos, char|
    new_map[pos] = char
  end
  map = new_map
  new_map = {}
  map.select { |pos, char| char == "v" } .each do |pos, char|
    next_pos = [pos.first, (pos.last + 1) % height]
    unless map.has_key?(next_pos)
      new_map[next_pos] = char
      moved = true
    else
      new_map[pos] = char
    end
  end
  map.reject { |pos, char| char == "v" } .each do |pos, char|
    new_map[pos] = char
  end
  map = new_map
  print_map(map, width, height)
  i += 1
  break unless moved
end

a = i

# Part 2
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
