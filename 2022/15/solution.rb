require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
row = 2000000

# input = sample_input
# row = 10

input.map! { |l| l.scan(/[-\d]+/).map(&:to_i) }

def manhattan_distance(x, y, dx, dy)
  (x - dx).abs + (y - dy).abs
end

# Part 1
beacons = []
sensors = []
distances = {}
input.each do |sensor|
  x, y, bx, by = sensor
  sensors << [x, y]
  beacons << [bx, by] 
  distances[[x,y]] = manhattan_distance(x,y,bx,by)
end

ranges = []
sensors.each do |x, y|
  distance = manhattan_distance(x, y, x, row)
  sensor_distance = distances[[x,y]]
  if distance <= sensor_distance
    slack = sensor_distance - distance
    ranges << ((x-slack)..(x+slack))
  end
end

min = ranges.map(&:min).min
max = ranges.map(&:max).max

# 5511201
a = max - min # in both sample and real inputs, only one beacon in that row

# Part 2
alias md manhattan_distance

b = nil
# (0..10000).each do |r|
(0..(row * 2)).each do |r|
  ranges = []
  relevant_sensors = sensors.each do |sensor|
    x, y = sensor
    distance = md(x, y, x, r)
    if distance <= distances[sensor]
      slack = distances[sensor] - distance
      ranges << ((x-slack)..(x+slack))
    end
  end

  min = ranges.map(&:min).min
  max = ranges.map(&:max).max

  x = min
  while x < max
    found = false
    ranges.each do |range|
      if range.include?(x)
        found = true
        x = range.max + 1
      end
    end
    next if found
    b = (x * 4000000) + r
    break
  end

  break unless b.nil?
end

# 11318723411840
# takes 51 seconds

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
