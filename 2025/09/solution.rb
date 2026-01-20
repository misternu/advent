require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
input = input.map { |l| l.map(&:to_i) }

def area(tile1, tile2)
  width = (tile1[0] - tile2[0]).abs + 1
  height = (tile1[1] - tile2[1]).abs + 1
  width * height
end

a = input.combination(2).reduce(0) do |max, pair|
  val = area(*pair)
  val > max ? val : max
end

# Part 2
def point_in_polygon?(x, y, polygon)
  inside = false
  polygon.each_cons(2) do |(x1, y1), (x2, y2)|
    inside = !inside if (y1 > y) != (y2 > y) && x < (x2 - x1) * (y - y1) / (y2 - y1) + x1
  end
  inside
end

def point_on_segment?(x, y, seg_start, seg_end)
  x1, y1 = seg_start
  x2, y2 = seg_end
  (y1 == y2 && y == y1 && (x1 < x2 ? x.between?(x1, x2) : x.between?(x2, x1))) ||
    (x1 == x2 && x == x1 && (y1 < y2 ? y.between(y1, y2) : y.between?(y2, y1)))
end

def segments_properly_intersect?(seg1, seg2)
  (x1, y1), (x2, y2) = seg1
  (x3, y3), (x4, y4) = seg2

  o1 = orientation([x1, y1], [x2, y2], [x3, y3])
  o2 = orientation([x1, y1], [x2, y2], [x4, y4])
  o3 = orientation([x3, y3], [x4, y4], [x1, y1])
  o4 = orientation([x3, y3], [x4, y4], [x2, y2])

  o1 != o2 && o3 != o4
end

b = input.combination(2).reduce(0) do |max, pair|
  val = area(*pair)
  next max unless val > max

  (x1, y1), (x2, y2) = pair
  next max unless point_in_polygon?([x2, y1], input)
  next max unless point_in_polygon?([x1, y2], input)

  next max if input.each_cons(2).any? do |edge|
    
  end
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
