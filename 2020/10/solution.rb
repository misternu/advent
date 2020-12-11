require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')



# Part 1
jolts = input.dup
jolts << jolts.max + 3
counts = Hash.new(0)
output = 0
while jolts.length > 0
  minimum = jolts.min
  jolts.delete(minimum)
  counts[minimum - output] += 1
  output = minimum
end
p counts
a = counts[1] * counts[3]

# Part 2


def search(memo, bag, sequence = [0])
  if memo[sequence.last]
    return memo[sequence.last]
  end
  if bag.empty?
    memo[sequence.last] = 1
    return 1
  end
  socket = sequence.last
  choices = bag.select { |n| n - socket < 4 }
  output = choices.sum do |choice|
    new_bag = bag.dup
    new_bag.delete(choice)
    new_bag.reject! { |n| n < choice }
    search(memo, new_bag, sequence + [choice])
  end
  memo[sequence.last] = output
  output
end


jolts = input.dup
jolts << jolts.max + 3

b = search(Hash.new, jolts)



helper.output(a, b)
