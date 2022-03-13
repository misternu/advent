require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
places = helper.line_separated_strings('input.txt').map do |l|
  l.split('').map do |char|
    char == "L" ? :L : nil
  end
end
# MemoryProfiler.start(allow_files: __FILE__)

# Solution to part one stolen and refactored from a reddit thread

NEIGHBORS_OFFSET = [[0, 1], [0, -1], [1, 0], [1, 1], [1, -1], [-1, 0], [-1, 1], [-1, -1]]

def neighbors(places, x, y)
  width = places.first.length
  height = places.length
  NEIGHBORS_OFFSET.filter_map do |dx, dy|
    next if x + dx < 0 ||
            x + dx >= width ||
            y + dy < 0 ||
            y + dy >= height
    places[y + dy][x + dx]
  end
end

while true
  next_places = places.each_with_index.map do |row, y|
    row.each_with_index.map do |place, x|
      count = neighbors(places, x, y).count(:T)
      next nil if place.nil?
      if place == :L
        count == 0 ? :T : :L
      else
        count >= 4 ? :L : :T
      end
    end
  end

  break if next_places == places
  places = next_places
end

p places.flatten.count(:T)
