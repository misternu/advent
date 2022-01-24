require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, script_file: __FILE__)
input = helper.auto_parse

# Part 1
input.combination(2).each { |args| p args.reduce(&:*) if args.sum == 2020 }

# Part 2
input.combination(3).each { |args| p args.reduce(&:*) if args.sum == 2020 }
