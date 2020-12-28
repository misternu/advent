require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, script_file: __FILE__)
input = helper.line_separated_strings('input.txt')

# Part 1
# 244
width = input.first.length
a = (0...input.length).count { |y| input[y][(y * 3) % width] == '#' }

# Part 2
# 9406609920
vectors = [[1,1], [3,1], [5,1], [7,1], [1,2]]
counts = vectors.map do |right, down|
  (0...input.length/down).count do |y|
    dy = down * y
    dx = y * right % width
    input[dy][dx] == '#'
  end
end
b = counts.reduce(&:*)

helper.output(a, b)
