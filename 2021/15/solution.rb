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
chitin = Hash.new
input.each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    chitin[[x, y]] = char.to_i
  end
end
width = input.first.length
height = input.length


# Part 1
queue = [[0,0,0]]
memo = {}
a = nil
# until queue.empty? do
# # 40.times do
#   x, y, risk = queue.shift
#   if m = memo[[x, y]]
#     memo[[x,y]] = risk if risk < m
#   else
#     memo[[x,y]] = risk
#   end
#   if x == width - 1 && y == height - 1
#     a = risk
#     break
#   end
#   neighbors = [[x,y-1],[x+1,y],[x,y+1],[x-1,y]].select do |pos|
#     chitin.has_key?(pos)
#   end
#   neighbors.each do |dx, dy|
#     queue << [dx, dy, risk + chitin[[dx, dy]]]
#   end
#   queue.select! do |dx, dy, drisk|
#     m = memo[[dx, dy]]
#     m.nil? || drisk < m
#   end
#   queue.sort_by! do |dx, dy, drisk|
#     [drisk, (width-1-dx)+(height-1-dy)]
#   end
# end



# Part 2
(0..4).each do |cy|
  (0..4).each do |cx|
    next if cy == 0 && cx == 0
    input.each_with_index do |line, y|
      line.split('').each_with_index do |char, x|
        location = [x + cx*width, y + cy*height]
        chitin[location] = (char.to_i + cx + cy - 1) % 9 + 1
      end
    end
  end
end
width = width * 5
height = height * 5
# (0...height).each do |y|
#   line = (0...width).map { |x| chitin[[x,y]] }.join
#   puts line
# end

queue = [[0,0,0]]
memo = {}
b = nil
until queue.empty? do
# # 40.times do
  x, y, risk = queue.shift
  # p (width-1-x) + (height-1-y)
  if m = memo[[x, y]]
    memo[[x,y]] = risk if risk < m
  else
    memo[[x,y]] = risk
  end
  if x == width - 1 && y == height - 1
    b = risk
    break
  end
  neighbors = [[x,y-1],[x+1,y],[x,y+1],[x-1,y]].select do |pos|
    chitin.has_key?(pos)
  end
  neighbors.each do |dx, dy|
    queue << [dx, dy, risk + chitin[[dx, dy]]]
  end
  queue.select! do |dx, dy, drisk|
    m = memo[[dx, dy]]
    m.nil? || drisk < m
  end
  queue.sort_by! do |dx, dy, drisk|
    [drisk, (width-1-dx)+(height-1-dy)]
  end
end




# MemoryProfiler.stop.pretty_print
helper.output(a, b)
