require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

lines = helper.line_separated_strings('example1.txt')

# Part 1
map = Hash.new
lines.each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    if ["#", "."].include?(char)
      map[[x,y]] = char
    end
  end
end

(0..20).each do |y|
  puts (0..20).map { |x|
    map[[x, y]] || " "
  }.join
end

y_top = 2
x_left = 2
walls = map.select { |k,v| v == "#" }
x_right = walls.keys.map(&:first).max
p y_bottom = walls.keys.map(&:last).max

# Part 2
input
