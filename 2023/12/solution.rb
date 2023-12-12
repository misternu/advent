require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = sample_input

# Part 1
input = input.map do |line|
  pattern, numbers = line.split
  numbers = numbers.split(",").map(&:to_i)
  [pattern, numbers]
end


def arrange(pattern, numbers)
  return 0 if pattern.empty? && !numbers.empty?
  return 1 if pattern.empty? && numbers.empty?
  hash_count = pattern.chars.count("#")
  return 0 if numbers.empty? && hash_count > 0
  return 1 if numbers.empty? && hash_count == 0
  nxt = arrange(pattern[1..-1].to_s, numbers)
  return nxt if pattern[0] == "."
  
  num = numbers.first
  count = pattern.chars.index(".") || pattern.length

  return arrange(pattern[count..-1].to_s, numbers) if count < num
  return nxt if pattern[num] == "#"
  return arrange(pattern[(num+1)..-1].to_s, numbers[1..-1]) if pattern[0] == "#"
  nxt + arrange(pattern[(num+1)..-1].to_s, numbers[1..-1])
end

a = input.sum do |pattern, numbers|
  arrange(pattern, numbers)
end

# Part 2
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
