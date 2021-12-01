require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse

# Part 1
a = (0..input.length-2).count { |i| input[i] < input[i+1] }

# Part 2
b = (0..input.length-4).count { |i| input[i] < input[i+3] }

helper.output(a, b)
