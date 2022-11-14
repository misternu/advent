require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse

UP = '('.freeze
DOWN = ')'.freeze

# Part 1
a = input.count(UP) - input.count(DOWN)

# Part 2
floor = 0
b = 1 + input.each_char.find_index do |c|
  if c == UP
    floor += 1
  else
    floor -= 1
  end
  floor < 0
end

helper.output(a, b)
