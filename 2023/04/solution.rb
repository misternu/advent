require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
score = 0
counts = {}
input.each_with_index do |round, i|
  _, string = round.split(":")
  winners, numbers = string.split("|").map(&:strip).map do |set|
    set.scan(/\d+/).map(&:to_i)
  end
  count = numbers.count { |n| winners.include?(n) }
  if count > 0
    score += 2 ** (count - 1)
  end
  counts[i] = count
end

a = score

# Part 2
tally = 0
cards = (0...input.length).map { |i| [i, 1] } .to_h
(0...input.length).each do |i|
  n = counts[i]
  stack = cards[i]
  ((i+1)..(i+n)).each do |j|
    cards[j] += stack
  end
end
b = cards.values.sum



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
