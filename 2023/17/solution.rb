require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.send(:open_file, 'sample_input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = sample_input

# Part 1

map = {}
input.each_with_index do |line, y|
  line.chars.each_with_index do |ch, x|
    map[[x,y]] = ch.to_i
  end
end
width = input.first.length
height = input.length

class HeatLoss
  def initialize(map)
    @map = map
    @memo_row = {}
    @memo_col = {}
  end

  def loss_at(pos)
    @map[pos]
  end

  def loss_row(y, x_range)
    @memo_row[[y, x_range.min, x_range.max]] ||= x_range.sum { |x| loss_at([x, y]) }
  end

  def loss_col(x, y_range)
    @memo_col[[x, y_range.min, y_range.max]] ||= y_range.sum { |y| loss_at([x, y]) }
  end
end

class Neighbors
  def initialize(map, width, height)
    @map, @width, @height = map, width, height
    @memo = {}
  end

  def for(pos, last_dir)
    @memo[pos] ||= up(pos) + right(pos) + down(pos) + left(pos)
  end

  def up(pos)
    []
  end

  def right(pos)
    []
  end

  def down(pos)
    []
  end

  def left(pos)
    []
  end
end

heat_loss = HeatLoss.new(map)
neighbors = Neighbors.new(map, width, height)
least_loss = {}
queue = [{ pos: [0,0], last_dir: nil, heat_loss: 0 }]

until queue.empty?
  h = queue.shift
  pos = h[:pos]
  heat_loss = h[:heat_loss]

  next if pos == [width - 1, height-1]
  queue = queue + neighbors.for(pos)
end

a = nil

# Part 2
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
