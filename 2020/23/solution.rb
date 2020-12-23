require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = "487912365"
sample_input = "389125467"

def step(cups, number = 9)
  head = cups.shift
  three = cups.shift(3)

  destination = ((head - 2) % number) + 1
  exclude = [head] + three
  while exclude.include?(destination)
    destination = ((destination - 2) % number) + 1
  end
  destination_index = cups.index(destination)

  cups = [head] + cups[0..destination_index] + three + cups[destination_index+1..-1]
  cups.rotate(1)
end


# Part 1
# 89573246
cups = input.split('').map(&:to_i)

100.times do
  cups = step(cups)
end

one_index = cups.index(1)
a = cups.rotate(one_index)[1..-1].join

# Part 2
one_million = 1_000_000
ten_million = 10_000_000
cups = sample_input.split('').map(&:to_i) + (10..one_million).to_a

now = Time.now
(1..ten_million).each do |i|
  if i % 1000 == 0
    p i
    puts "pace #{(Time.now - now) * 10_000 / 60} minutes"
    now = Time.now
  end
  cups = step(cups, one_million)
end

one_index = cups.index(1)
b = cups[one_index+1..one_index+2].reduce(&:*)
# b = nil



helper.output(a, b)
