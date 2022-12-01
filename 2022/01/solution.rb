require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
input = input.split("\n\n").map { |l| l.split("\n").map(&:to_i) }

# Part 1
a = input.map { |e| e.sum } .max

# Part 2
b = input.map { |e| e.sum } .sort.last(3).sum

helper.output(a, b)

# Time: 00:03:55.54
