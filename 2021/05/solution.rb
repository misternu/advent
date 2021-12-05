require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2".split("\n")
# input = sample_input

input.map!(&:split).map! do |l|
  [l.first, l.last].map do |n|
    n.split(',').map(&:to_i)
  end
end

# Part 1
covered = Hash.new(0)
input.each do |a, b|
  if a.first == b.first
    x_incr = 0
    y_incr = a.last > b.last ? -1 : 1
    distance = (a.last-b.last).abs
  elsif a.last == b.last
    x_incr = a.first > b.first ? -1 : 1
    y_incr = 0
    distance = (a.first-b.first).abs
  else
    next
  end
  (0..distance).each do |offset|
    covered[[a.first + (offset * x_incr), a.last + (offset * y_incr)]] += 1
  end
end
a = covered.values.count { |n| n != 1 }

# Part 2
input.each do |a, b|
  if a.first == b.first
    next
  elsif a.last == b.last
    next
  else
    x_incr = a.first > b.first ? -1 : 1
    y_incr = a.last > b.last ? -1 : 1
    distance = (a.first-b.first).abs
  end
  (0..distance).each do |offset|
    covered[[a.first + (offset * x_incr), a.last + (offset * y_incr)]] += 1
  end
end
b = covered.values.count { |n| n != 1 }

# print sample output in style of question
# (0..9).each do |y|
#   line = (0..9).map do |x|
#     covered[[x,y]] > 0 ? covered[[x,y]].to_s : "."
#   end .join
#   puts line
# end

helper.output(a, b)
