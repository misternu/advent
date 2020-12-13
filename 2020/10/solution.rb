require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse.sort!
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')



# Part 1
jolts = input.dup + [input.max + 3]
counts = Hash.new(0)
last = 0
while jolts.length > 0
  minimum = jolts.delete(jolts.min)
  counts[minimum - last] += 1
  last = minimum
end
a = counts[1] * counts[3]



# Part 2
def search(bag, sequence = [0], memo = Hash.new)
  socket = sequence.last
  return memo[socket] if memo[socket]
  if bag.empty?
    memo[socket] = 1
    return 1
  end
  choices = bag.take_while { |n| n - socket < 4 }
  output = choices.sum do |choice|
    new_bag = bag.reject { |n| n <= choice }
    search(new_bag, sequence + [choice], memo)
  end
  memo[socket] = output
  output
end

require 'benchmark'
jolts = input.dup

b = search(jolts)

# puts Benchmark.measure { 1000.times do search(jolts) end }



helper.output(a, b)
