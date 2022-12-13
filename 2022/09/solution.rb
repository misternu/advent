require_relative '../../lib/advent_helper'
require 'set'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

input.map! { |x, y| [x.to_sym, y.to_i] }

head = [0,0]
tail = [0,0]
visited = Set.new([[0,0]])

DIRS = {
  U: [0, -1],
  D: [0, 1],
  L: [-1, 0],
  R: [1, 0]
}

input.each do |instruction|
  change = DIRS[instruction.first]
  amount = instruction.last
  amount.times do
    head = head.zip(change).map(&:sum)
    if head.zip(tail).map { |x, y| (x - y).abs }.any? { |v| v > 1 }
      tail = head.zip(change).map { |x, y| x - y }
      visited << tail
    end
  end
end

# Part 1
a = visited.count

# Part 2

pos = [0, 0]
path = []
input.each do |instruction|
  change = DIRS[instruction.first]
  amount = instruction.last
  amount.times do
    pos = pos.zip(change).map(&:sum)
    path << pos
  end
end
paths = [path]

9.times do
  prev_path = paths.last
  new_path = []
  tail = [0, 0]
  prev_path.each_with_index do |pos, i|
    if pos.zip(tail).map { |x, y| (x - y).abs }.any? { |v| v > 1 }
      x_0, x_1 = pos
      y_0, y_1 = tail
      if y_0 < x_0
        y_0 += 1
      elsif y_0 > x_0
        y_0 -= 1
      end
      if y_1 < x_1
        y_1 += 1
      elsif y_1 > x_1
        y_1 -= 1
      end
      tail = [y_0, y_1]
    end
    new_path << tail.dup
  end
  paths << new_path
end

b = paths.last.uniq.length



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
# 00:54:40.56
