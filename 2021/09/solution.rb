require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# require 'memory_profiler'
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
input.map! { |l| l.split('').map(&:to_i) }


# Part 1
width = input.first.length
height = input.length
low_point_heights = []
low_point_locations = []
(0...height).each do |y|
  (0...width).each do |x|
    this_height = input[y][x]
    adjacent = []
    if y != 0
      adjacent << input[y-1][x]
    end
    if x != 0
      adjacent << input[y][x-1]
    end
    if y < height - 1
      adjacent << input[y+1][x]
    end
    if x < width - 1
      adjacent << input[y][x+1]
    end
    if adjacent.all? { |n| n > this_height }
      low_point_heights << this_height
      low_point_locations << [x, y]
    end 
  end
end

a = low_point_heights.sum { |n| n+1 }

# Part 2
def basin(x, y, topo)
  width = topo.first.length
  height = topo.length
  points = [[x,y]]
  last_length = 1
  while true
    points.each do |i, j|
      if i != 0 && !points.include?([i-1, j]) && topo[j][i-1] != 9
        points << [i-1, j]
      end
      if j != 0 && !points.include?([i, j-1]) && topo[j-1][i] != 9
        points << [i, j-1]
      end
      if i < width - 1 && !points.include?([i+1, j]) && topo[j][i+1] != 9
        points << [i+1, j]
      end
      if j < height - 1 && !points.include?([i, j+1]) && topo[j+1][i] != 9
        points << [i, j+1]
      end
    end
    break if points.length == last_length
    last_length = points.length
  end
  points
end
basins = []
low_point_locations.each do |x, y|
  basins << basin(x, y, input).length
end
b = basins.sort.last(3).reduce(&:*)



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
