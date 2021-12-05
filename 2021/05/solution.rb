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
    if a.last < b.last
      (a.last..b.last).each do |y|
        covered[[a.first, y]] += 1
      end
    else
      (b.last..a.last).each do |y|
        covered[[a.first, y]] += 1
      end
    end
  elsif a.last == b.last
    if a.first < b.first
      (a.first..b.first).each do |x|
        covered[[x, a.last]] += 1
      end
    else
      (b.first..a.first).each do |x|
        covered[[x, a.last]] += 1
      end
    end
  end
end
a = covered.values.count { |n| n != 1}

# Part 2
covered = Hash.new(0)
input.each do |a, b|
  if a.first == b.first
    if a.last < b.last
      (a.last..b.last).each do |y|
        covered[[a.first, y]] += 1
      end
    else
      (b.last..a.last).each do |y|
        covered[[a.first, y]] += 1
      end
    end
  elsif a.last == b.last
    if a.first < b.first
      (a.first..b.first).each do |x|
        covered[[x, a.last]] += 1
      end
    else
      (b.first..a.first).each do |x|
        covered[[x, a.last]] += 1
      end
    end
  else
    distance = (a.first - b.first).abs
    if a.first < b.first
      if a.last < b.last
        (0..distance).each do |offset|
          covered[[a.first + offset, a.last + offset]] += 1
        end
      else
        (0..distance).each do |offset|
          covered[[a.first + offset, a.last - offset]] += 1
        end
      end
    else
      if a.last < b.last
        (0..distance).each do |offset|
          covered[[a.first - offset, a.last + offset]] += 1
        end
      else
        (0..distance).each do |offset|
          covered[[a.first - offset, a.last - offset]] += 1
        end
      end
    end
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
