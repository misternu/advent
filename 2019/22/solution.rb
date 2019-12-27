require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt')

test_deck = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

def increment(deck, n)
  len = deck.length
  new_deck = []
  i = 0
  deck.each do |card|
    new_deck[i] = card
    i = (i + n) % len
  end
  new_deck
end

def cut(deck, n)
  deck[n..-1] + deck[0...n]
end

example1 = [
  "deal with increment 7",
  "deal into new stack",
  "deal into new stack"
]

example2 = [
  "cut 6",
  "deal with increment 7",
  "deal into new stack"
]

example3 = [
  "deal with increment 7",
  "deal with increment 9",
  "cut -2"
]

def deal_index(len, i)
  len - 1 - i
end

def increment_index(len, n, i)
  (i * n) % len
end

def cut_index(len, n, i)
  (i - n) % len
end

# Part 1
length = 10007
i = 2019
input.each { |line|
  if line =~ /deal into new/
    i = deal_index(length, i)
  elsif line =~ /deal with increment/
    number = line.split(' ').last.to_i
    i = increment_index(length, number, i)
  elsif line =~ /cut/
    number = line.split(' ').last.to_i
    i = cut_index(length, number, i)
  end
}
p i

# Part 2
length = 119315717514047
repetitions = 101741582076661
i = 2020
known = Hash.new

until known[i]
  start_index = i
  new_index = i
  input.each { |line|
    if line =~ /deal into new/
      new_index = deal_index(length, new_index)
    elsif line =~ /deal with increment/
      number = line.split(' ').last.to_i
      new_index = increment_index(length, number, new_index)
    elsif line =~ /cut/
      number = line.split(' ').last.to_i
      new_index = cut_index(length, number, new_index)
    end
  }
  known[start_index] = new_index
  i = new_index
  if known.length > 100
    break
  end
end

puts known.map { |k, v| (k - v).abs }.sort