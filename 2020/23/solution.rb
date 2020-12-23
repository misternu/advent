require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = "487912365"
sample_input = "389125467"

def step(next_cup, head, number = 9)
  head
  picked = []
  pick = head
  3.times do
    picked << next_cup[pick]
    pick = picked.last
  end

  destination = ((head - 2) % number) + 1
  while picked.include?(destination)
    destination = ((destination - 2) % number) + 1
  end
  destination

  a = next_cup[picked.last]
  b = next_cup[destination]

  next_cup[destination] = picked.first
  next_cup[head] = a
  next_cup[picked.last] = b
  a
end


# Part 1
# 89573246
next_cup = Hash.new
input_integers = input.split('').map(&:to_i)
(0..7).each do |i|
  next_cup[input_integers[i]] = input_integers[i+1]
end
next_cup[input_integers.last] = input_integers.first

head = input_integers.first
100.times do
  head = step(next_cup, head)
end

until head == 1
  head = next_cup[head]
end

result = []
8.times do
  result << next_cup[head]
  head = next_cup[head]
end

a = result.map(&:to_s).join

# Part 2
one_million = 1_000_000
ten_million = 10_000_000
next_cup = Hash.new
input_integers = input.split('').map(&:to_i)
(0..7).each do |i|
  next_cup[input_integers[i]] = input_integers[i+1]
end
next_cup[input_integers.last] = 10
(10...one_million).each do |n|
  next_cup[n] = n + 1
end
next_cup[one_million] = input_integers.first

now = Time.now
head = input_integers.first
ten_million.times do
  head = step(next_cup, head, one_million)
end

until head == 1
  head = next_cup[head]
end

n = next_cup[head]
m = next_cup[n]

b = n * m



helper.output(a, b)
