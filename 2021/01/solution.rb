require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse

# Part 1
a = (0..input.length-2).count { |i| input[i] < input[i+1] }

# Part 2
sliding = (0..input.length-3).map { |i| input[i..(i+2)].reduce(&:+) }
b = (0..sliding.length-2).count { |i| sliding[i] < sliding[i+1] }

helper.output(a, b)
