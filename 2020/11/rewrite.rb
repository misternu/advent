require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

DIRECTIONS = [
  [0,-1],
  [1,-1],
  [1,0],
  [1,1],
  [0,1],
  [-1,1],
  [-1,0],
  [-1,-1]
].freeze

height = input.length
width = input.first.length
seats = Hash.new
input.each_with_index do |row, y|
  row.chars.each_with_index do |col, x|
    if col == "L"
      seats[[x,y]] = true
    end
  end
end
givens = { height: height, width: width, seats: seats, memo: {} }

def neighbors(pos, options)
  return options[:memo][pos] if options[:memo][pos]
  x, y = pos
  n = DIRECTIONS.filter_map do |dx, dy|
    next if x + dx < 0
    next if y + dy < 0
    next if x + dx >= options[:width]
    next if y + dy >= options[:height]
    [x + dx, y + dy]
  end
  options[:memo][pos] = n
end

def occupied(pos, taken, options = {})
  if taken[pos]
    count = 0
    neighbors(pos, options).each do |s|
      if taken[s]
        count += 1
      end
      return false if count >= 4
    end
    true
  else
    neighbors(pos, options).none? { |s| taken[s] }
  end
end

taken = seats.dup
changed = []
while true
  new_taken = taken.inject({}) { |h, (k,v)| h[k] = occupied(k, taken, givens); h }
  break unless new_taken.any? { |k, v| taken[k] != v }
  taken = new_taken
end

a = taken.values.count(true)

b = nil

# MemoryProfiler.stop.pretty_print

helper.output(a, b)
