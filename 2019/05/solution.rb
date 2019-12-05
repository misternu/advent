require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

helper = AdventHelper.new(script_root:__dir__)

input = helper.comma_separated_strings('input.txt').map(&:to_i)

# Part 1
computer = IntcodeComputer.new(input, IntcodeIO.new([1]))
computer.run

# # Part 2
computer = IntcodeComputer.new(input, IntcodeIO.new([5]))
computer.run
