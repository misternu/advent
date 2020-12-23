require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = "487912365"
sample_input = "389125467"

def step(next_cup, head, number = 9)
  x = next_cup[head]
  y = next_cup[x]
  z = next_cup[y]

  dest = (head - 1) % number
  while x == dest || y == dest || z == dest
    dest = (dest - 1) % number
  end

  a = next_cup[z]
  b = next_cup[dest]

  next_cup[dest] = x
  next_cup[head] = a
  next_cup[z] = b
  a
end


# Part 1
# 89573246
next_cup = Hash.new
input_integers = input.split('').map(&:to_i).map { |n| n - 1 }
(0..7).each do |i|
  next_cup[input_integers[i]] = input_integers[i+1]
end
next_cup[input_integers.last] = input_integers.first

head = input_integers.first
100.times do
  head = step(next_cup, head)
end

head = 0
result = []
8.times do
  result << next_cup[head] + 1
  head = next_cup[head]
end

a = result.map(&:to_s).join

# Part 2
# 2029056128
one_million = 1_000_000
ten_million = 10_000_000
next_cup = Hash.new
input_integers = input.split('').map(&:to_i).map { |n| n - 1 }
(0..7).each do |i|
  next_cup[input_integers[i]] = input_integers[i+1]
end
next_cup[input_integers.last] = 9
(9...one_million-1).each do |n|
  next_cup[n] = n + 1
end
next_cup[one_million - 1] = input_integers.first

head = input_integers.first
ten_million.times do
  head = step(next_cup, head, one_million)
end

n = next_cup[0] + 1
m = next_cup[n - 1] + 1

b = n * m



helper.output(a, b)
