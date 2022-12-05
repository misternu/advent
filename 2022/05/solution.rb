require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# input = sample_input

stacks, instrs = input.split("\n\n")
stacks = stacks.split("\n")[..-2]
length = stacks.first.length
stack_hash = Hash.new { |h, k| h[k] = [] }
stacks.each do |line|
  (0...length).step(4).with_index do |n, i|
    letter = line[n+1]
    if letter != ' '
      stack_hash[i + 1] << letter
    end
  end
end
instrs = instrs.split("\n").map {|l| l.scan(/\d+/).map(&:to_i) }

# Part 1
# instrs.each do |instr|
#   q, o, d = instr
#   q.times do
#     item = stack_hash[o].shift
#     stack_hash[d].unshift(item)
#   end
# end

# a = (1..9).map { |i| stack_hash[i].first } .join
a = nil

# Part 2
instrs.each do |instr|
  q, o, d = instr
  moving = []
  q.times do
    moving << stack_hash[o].shift
  end
  stack_hash[d] = moving + stack_hash[d]
end
b = (1..9).map { |i| stack_hash[i].first } .join


helper.output(a, b)
# 00:28:19.26
