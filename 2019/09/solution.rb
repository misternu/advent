require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

helper = AdventHelper.new(script_root:__dir__)

program = helper.comma_separated_strings('input.txt').map(&:to_i)

# Part 1
computer = IntcodeComputer.new(program, IntcodeIO.new([1]))
p computer.run.first

# Part 2
computer = IntcodeComputer.new(program, IntcodeIO.new([2]))
p computer.run.first