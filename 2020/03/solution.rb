require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt').map { |line| line.split('') }
# input = helper.comma_separated_strings('input.txt')



# Part 1
x = 0
y = 0
width = input.first.length

count = 0
while y < input.length
  count += input[y][x] == '#' ? 1 : 0
  y += 1
  x = (x + 3) % width
end
a = count

def risk(right, down, input)
  x = 0
  y = 0
  width = input.first.length

  count = 0
  while y < input.length
    count += input[y][x] == '#' ? 1 : 0
    y += down
    x = (x + right) % width
  end
  a = count
end

# Part 2
b =[[1,1], [3,1], [5,1], [7,1], [1,2]].map { |right, down| risk(right,down,input) } .reduce(&:*)



helper.output(a, b)
