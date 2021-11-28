require_relative '../../lib/advent_helper'
require_relative 'deck'
require_relative 'instruction_parser'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt')
instructions = InstructionParser.parse(input)

# part 1
length = 10007
n = 2019

deck = Deck.new(length)
deck.apply_all(instructions)
a = deck.index_of(n)

# part 2
# length = 119315717514047
# repetitions = 101741582076661
# i = 2020

helper.output(a, nil)
