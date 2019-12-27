require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

CHARS = {
  10 => "\n",
  35 => "#",
  46 => ".",
  60 => "<",
  62 => ">",
  76 => "v",
  94 => "^"
}

helper = AdventHelper.new(script_root:__dir__)

input = helper.comma_separated_strings('input.txt').map(&:to_i)

def    up(pos); [pos[0], pos[1] - 1] end
def right(pos); [pos[0] + 1, pos[1]] end
def  down(pos); [pos[0], pos[1] + 1] end
def  left(pos); [pos[0] - 1, pos[1]] end

# Part 1
computer = IntcodeComputer.new(input, IntcodeIO.new([]))
image = computer.run

string = image.map { |i| CHARS[i] }.join

height = 0
width = string.split('').find_index("\n")

grid = Hash.new
rows = string.split("\n").each_with_index do |row, y|
  row.split('').each_with_index do |i, x|
    grid[[x,y]] = i
  end
  height += 1
end

(1..height-2).each do |y|
  (1..width-2).each do |x|
    next unless grid[[x, y]] == "#"
    if [up([x,y]), right([x,y]), down([x,y]), left([x,y])].all? { |pos| grid[pos] == "#"}
      grid[[x,y]] = "O"
    end
  end
end

intersections = grid.select { |k, v| v == "O" }
p intersections.keys.map { |x, y| x * y }.sum

# Part 2
input2 = input.dup
input2[0] = 2

# A L,8,R,10,L,10
# B R,10,L,8,L,8,L,10
# A L,8,R,10,L,10
# C L,4,L,6,L,8,L,8
# B R,10,L,8,L,8,L,10
# C L,4,L,6,L,8,L,8
# A L,8,R,10,L,10
# C L,4,L,6,L,8,L,8
# B R,10,L,8,L,8,L,10
# C L,4,L,6,L,8,L,8

program = [
  "A,B,A,C,B,C,A,C,B,C\n",
  "L,8,R,10,L,10\n",
  "R,10,L,8,L,8,L,10\n",
  "L,4,L,6,L,8,L,8\n",
  "n\n"
].map { |r| r.each_byte.to_a } .flatten

computer = IntcodeComputer.new(input2, IntcodeIO.new(program))
p computer.run.last

