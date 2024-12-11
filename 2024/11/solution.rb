require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')

# input = sample_input
input = input.first.split(' ').map(&:to_i)

# Part 1

stones = input.dup

25.times do
  new_stones = []

  stones.each do |stone|
    if stone == 0
      new_stones << 1
      next
    end

    string = stone.to_s
    if string.length % 2 == 0
      new_stones << string[0...(string.length / 2)].to_i
      new_stones << string[(string.length / 2)..].to_i
      next
    end

    new_stones << stone * 2024
  end
  stones = new_stones
end

a = stones.length

# Part 2

def dig(number, depth, memo)
  return 1 if depth.zero?
  return memo[number][depth] if memo[number][depth]

  new_stones = []
  string = number.to_s

  if number.zero?
    new_stones << 1
  elsif string.length.even?
    new_stones << string[0...(string.length / 2)].to_i
    new_stones << string[(string.length / 2)..].to_i
  else
    new_stones << number * 2024
  end

  total = new_stones.sum do |new_stone|
    dig(new_stone, depth - 1, memo)
  end

  memo[number][depth] ||= total
  total
end

memo = Hash.new { |h, k| h[k] = [] }

stones = input.dup
b = stones.sum { |s| dig(s, 75, memo) }

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
