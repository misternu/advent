require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse

# Part 1
computer_a = IntcodeComputer.new(input.dup, IntcodeIO.new([]), ascii: true)
computer_a.run
program = <<~SPRING
  NOT B J
  NOT C T
  OR T J
  AND D J
  NOT A T
  OR T J
  WALK
SPRING
computer_a.io.add_string(program)
computer_a.resume
a = computer_a.io.print.last

# Part 2
computer_b = IntcodeComputer.new(input.dup, IntcodeIO.new([]), ascii: true)
computer_b.run
program = <<~SPRING
  NOT B J
  NOT C T
  OR T J
  AND D J
  AND H J
  NOT A T
  OR T J
  RUN
SPRING
computer_b.io.add_string(program)
computer_b.resume
b = computer_b.io.print.last

helper.output(a, b)
