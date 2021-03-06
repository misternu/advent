require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, script_file: __FILE__)
input = helper.send(:open_file, 'input.txt').read
responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }



# Part 1
# 6310
a = responses.sum { |r| r.inject(&:|).count }

# Part 2
# 3193
b = responses.sum { |r| r.inject(&:&).count }



helper.output(a, b)
