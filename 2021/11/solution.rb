require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input

octopuses = Hash.new
input.each_with_index do |line, y|
  line.split('').each_with_index do |n, x|
    octopuses[[x, y]] = n.to_i 
  end
end
locations = octopuses.keys

# Part 1
count = 0
100.times do
  octopuses.each do |k, v|
    octopuses[k] = v + 1
  end
  flashed = []
  while true
    flashes = octopuses.select { |k, v| v > 9 && !flashed.include?(k) } .keys
    break if flashes.empty?
    flashes.each do |flash|
      x, y = flash
      neighbors = [
        [x-1,y-1],
        [x,y-1],
        [x+1,y-1],
        [x-1,y],
        [x+1,y],
        [x-1,y+1],
        [x,y+1],
        [x+1,y+1]
      ].select { |k| locations.include?(k) } .each do |neighbor|
        octopuses[neighbor] += 1
      end
    end
    flashed += flashes
    count += flashes.length
  end
  flashed.each do |flash|
    octopuses[flash] = 0
  end
end
a = count


# Part 2
octopuses = Hash.new
input.each_with_index do |line, y|
  line.split('').each_with_index do |n, x|
    octopuses[[x, y]] = n.to_i 
  end
end
count = 0
while true do
  octopuses.each do |k, v|
    octopuses[k] = v + 1
  end
  flashed = []
  while true
    flashes = octopuses.select { |k, v| v > 9 && !flashed.include?(k) } .keys
    break if flashes.empty?
    flashes.each do |flash|
      x, y = flash
      neighbors = [
        [x-1,y-1],
        [x,y-1],
        [x+1,y-1],
        [x-1,y],
        [x+1,y],
        [x-1,y+1],
        [x,y+1],
        [x+1,y+1]
      ].select { |k| locations.include?(k) } .each do |neighbor|
        octopuses[neighbor] += 1
      end
    end
    flashed += flashes
  end
  flashed.each do |flash|
    octopuses[flash] = 0
  end
  count += 1
  break if flashed.count == 100
end
b = count



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
