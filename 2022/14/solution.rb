require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# MemoryProfiler.start(allow_files: __FILE__)

input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')

# input = sample_input

input = input.map { |l| l.split(" -> ").map { |p| p.split(",").map(&:to_i) } }

DIRS = {
  d: [0, 1],
  l: [-1, 1],
  r: [1, 1]
}

# Part 1
rocks = {}

input.each do |path|
  x, y = path.first
  path[1..].each do |pos|
    dx, dy = pos
    x_range = x <= dx ? x.upto(dx) : x.downto(dx)
    y_range = y <= dy ? y.upto(dy) : y.downto(dy)
    y_range.each do |row|
      x_range.each do |col|
        rocks[[col,row]] = 2
      end
    end
    x, y = dx, dy
  end
end

sand_origin = [500, 0]
deepest = rocks.keys.map(&:last).max + 1
grains = 0
while true
  grain = sand_origin.dup

  while true do
    break if grain.last >= deepest

    down = grain.zip(DIRS[:d]).map(&:sum)
    unless rocks[down]
      grain = down
      next
    end

    left = grain.zip(DIRS[:l]).map(&:sum)
    unless rocks[left]
      grain = left
      next
    end

    right = grain.zip(DIRS[:r]).map(&:sum)
    unless rocks[right]
      grain = right
      next
    end

    rocks[grain] = 1
    grains += 1
    break
  end

  break if grain.last >= deepest
end

a = grains

# Part 2
rocks.delete_if { |k, v| v == 1 }
sand_origin = [500, 0]
grains = 0
while true
  grain = sand_origin.dup

  while true do
    down = grain.zip(DIRS[:d]).map(&:sum)
    unless rocks[down] || grain.last == deepest
      grain = down
      next
    end

    left = grain.zip(DIRS[:l]).map(&:sum)
    unless rocks[left] || grain.last == deepest
      grain = left
      next
    end

    right = grain.zip(DIRS[:r]).map(&:sum)
    unless rocks[right] || grain.last == deepest
      grain = right
      next
    end

    rocks[grain] = 1
    grains += 1
    break
  end

  break if grain == sand_origin
end

b = grains



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
