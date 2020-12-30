require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')


# Initial solution
# row_ids = input.map do |line|
#   row = line[0..6].split('').map { |c| c == 'B' ? '1' : '0' }.join.to_i(2)
#   col = line[7..-1].split('').map { |c| c == 'R' ? '1' : '0' }.join.to_i(2)
#   row * 8 + col
# end
# # Part 1
# a = row_ids.max

# # Part 2
# b = (row_ids.min..row_ids.max).sum - row_ids.sum



# Rewrite
row_ids = input.map do |line|
  line.split('').map { |c| ["B", "R"].include?(c) ? '1' : '0' }.join.to_i(2)
end
# Part 1
# 998
a = row_ids.max

# Part 2
# 676
b = (row_ids.min..row_ids.max).sum - row_ids.sum



helper.output(a, b)
