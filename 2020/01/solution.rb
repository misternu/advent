require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt').map(&:to_i)

# Part 1
input.combination(2).each { |args| p args.reduce(&:*) if args.sum == 2020 }

# Part 2
input.combination(3).each { |args| p args.reduce(&:*) if args.sum == 2020 }
