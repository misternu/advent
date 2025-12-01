require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1 & 2
input = input.map { |l| [l[0], l[1..].to_i] }
a = 0
b = 0
pos = 50
input.each do |dir, n|
  new_pos = (pos + (dir == "R" ? n : -n))
  if new_pos.negative?
    b -= ((new_pos - 1) / 100)
    pos.zero? && b -= 1
  elsif new_pos > 99
    b += (new_pos / 100)
  elsif new_pos.zero?
    b += 1
  end
  pos = new_pos % 100
  pos.zero? && a += 1
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
