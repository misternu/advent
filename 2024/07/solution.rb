require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

input = input.map { |l| l.map(&:to_i) }

# Part 1
def values(numbers, part_two = false)
  return numbers if numbers.length == 1

  last = numbers[-1]
  front = values(numbers[...-1], part_two)
  result = front.map { |v| last + v }
  result += front.map { |v| last * v }
  result += front.map { |v| (v.to_s + last.to_s).to_i } if part_two
  result
end

a = 0

input.each do |line|
  target = line[0]
  numbers = line[1..]
  a += target if values(numbers).include?(target)
end

# Part 2

b = 0

input.each do |line|
  target = line[0]
  numbers = line[1..]
  b += target if values(numbers, true).include?(target)
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
