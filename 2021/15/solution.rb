require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
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
queue = [[[0,0],0]]
cost_at = { [0,0] => 0 }
end_pos = [width-1, height-1]
until cost_at[end_pos]
  min = queue.min_by { |v| v.last }
  this = queue.delete(min)
  x, y = this.first
  cost = this.last
  neighbors = [[x,y-1],[x+1,y],[x,y+1],[x-1,y]]
  neighbors.each do |n|
    next unless chitin.has_key?(n)
    next if cost_at[n]
    cost_at[n] = cost + chitin[n]
    queue << [n, cost_at[n]]
  end
end
a = cost_at[end_pos]


# Part 2
(0..4).each do |cy|
  (0..4).each do |cx|
    next if cy == 0 && cx == 0
    (0...height).each do |y|
      (0...width).each do |x|
        num = chitin[[x,y]]
        location = [x + cx*width, y + cy*height]
        chitin[location] = (num + cx + cy - 1) % 9 + 1
      end
    end
  end
end
width = width * 5
height = height * 5
queue = [[[0,0],0]]
cost_at = { [0,0] => 0 }
end_pos = [width-1, height-1]
until cost_at[end_pos]
  min = queue.min_by { |v| v.last }
  this = queue.delete(min)
  x, y = this.first
  cost = this.last
  neighbors = [[x,y-1],[x+1,y],[x,y+1],[x-1,y]]
  neighbors.each do |n|
    next unless chitin.has_key?(n)
    next if cost_at[n]
    cost_at[n] = cost + chitin[n]
    queue << [n, cost_at[n]]
  end
end
b = cost_at[end_pos]



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
