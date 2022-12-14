require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')

# input = sample_input

input.map! { |l| l.split(" ") }

x = 1
signals = [1]
input.each do |op, num|
  case op
  when "noop"
    signals << x.dup
  when "addx"
    signals << x.dup
    x += num.to_i
    signals << x.dup
  end
end

def strength(signals, index)
  p index * signals[index-1]
end

# Part 1
a = [20, 60, 100, 140, 180, 220].sum { |v| strength(signals, v) }

# Part 2
output = []
row = []
signals.each_with_index do |value, index|
  if index % 40 == 0
    output << row
    row = []
  end
  pos = index % 40
  if (value - pos).abs < 2
    row << '#'
  else
    row << ' '
  end
end
output.each do |row|
  puts row.join
end
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
# 00:29:37.79
