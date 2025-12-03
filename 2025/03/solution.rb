require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
a = input.dup.sum do |l|
  chars = l.chars

  left = chars[...-1].map(&:to_i).max
  left_index = chars.index(left.to_s)
  right = chars[left_index+1..].map(&:to_i).max
  left * 10 + right  
end

# Part 2
b = input.dup.sum do |l|
  chars = l.chars

  val = 0
  j = 0
  12.downto(1).each do |i|
    digit = chars[j..-i].map(&:to_i).max
    j += chars[j..-i].index(digit.to_s) + 1
    val += digit * (10**(i - 1))
  end
  val
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
