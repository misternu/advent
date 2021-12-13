require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
split = input.index([])
dots = input[0...split].map { |x, y| [x.to_i, y.to_i] }
instructions = input[split+1..-1]


# Part 1
instructions.each do |instruction|
  direction = instruction[2]
  location = instruction[3].to_i
  dots.each_with_index do |pos, i|
    x,y = pos
    if direction == "y" && y > location
      dots[i] = [x, y - (2 * (y - location))]
    elsif direction == "x" && x > location
      dots[i] = [x - (2 * (x - location)), y]
    end
  end
end
a = nil

# Part 2
(0..5).each do |y|
  line = (0..39).map do |x|
    dots.include?([x,y]) ? '#' : ' '
  end
  puts line.join
end
b = nil



# MemoryProfiler.stop.pretty_print
# helper.output(a, b)
