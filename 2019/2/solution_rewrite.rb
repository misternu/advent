require_relative '../../lib/advent_helper'
require_relative 'intercode_computer'

helper = AdventHelper.new(script_root:__dir__)
input = helper.comma_separated_strings('input.txt').map(&:to_i)

# # Part 1
p IntcodeComputer.new(input, noun: 12, verb: 2).run[0]

# Part 2
target = 19690720
(0..99).to_a.repeated_permutation(2).each do |noun, verb|
  computer = IntcodeComputer.new(input, noun: noun, verb: verb)
  if computer.run[0] == target
    p 100 * noun + verb
    break
  end
end
