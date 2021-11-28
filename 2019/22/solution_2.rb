require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt')

example_1 = [
  "deal with increment 7",
  "deal into new stack",
  "deal into new stack",
]

example_1_solutions = %w(0 3 6 9 2 5 8 1 4 7).map(&:to_i)

example_2 = [
  "cut 6",
  "deal with increment 7",
  "deal into new stack",
]

example_2_solutions = %w(3 0 7 4 1 8 5 2 9 6).map(&:to_i)

example_3 = [
  "deal with increment 7",
  "deal with increment 9",
  "cut -2",
]

example_3_solutions = %w(6 3 0 7 4 1 8 5 2 9).map(&:to_i)

example_4 = [
  "deal into new stack",
  "cut -2",
  "deal with increment 7",
  "cut 8",
  "cut -4",
  "deal with increment 7",
  "cut 3",
  "deal with increment 9",
  "deal with increment 3",
  "cut -1",
]

example_4_solutions = %w(9 2 5 8 1 4 7 0 3 6).map(&:to_i)

def translate_line(line)
  case line
  when /deal into new/
    [:deal, nil]
  when /deal with increment/
    [:inc, line.split(' ').last.to_i]
  else
    [:cut, line.split(' ').last.to_i]
  end
end

def translate(instructions)
  instructions.map { |l| translate_line(l) }
end

def deal(length, i)
  (-i - 1) % length
end

def inc(length, i, n)
  (i * n) % length
end

def cut(length, i, n)
  (i - n) % length
end

def full_solve(instructions, length, i)
  ops = translate(instructions)
  ops.each do |op, n|
    case op
    when :deal
      i = deal(length, i)
    when :inc
      i = inc(length, i, n)
    when :cut
      i = cut(length, i, n)
    end
  end
  return i
end

# Initial Tests
(0..9).each do |i|
  unless full_solve(example_1, 10, i) == example_1_solutions.find_index(i)
    puts "example 1, index #{i}"
  end
  unless full_solve(example_2, 10, i) == example_2_solutions.find_index(i)
    puts "example 2, index #{i}"
  end
  unless full_solve(example_3, 10, i) == example_3_solutions.find_index(i)
    puts "example 3, index #{i}"
  end
  unless full_solve(example_4, 10, i) == example_4_solutions.find_index(i)
    puts "example 4, index #{i}"
  end
end


# Postulate 1: two deals cancel out
# example_1 = [

#   "deal with increment 7",
#   "deal into new stack",
#   "deal into new stack",
# ]
# (0..9).each do |i|
#   unless full_solve(["deal with increment 7"], 10, i) == example_1_solutions.find_index(i)
#     puts "postulate 1 fails for index #{i}"
#   end
# end

# # Postulate 2: two successive deals with increment can be multiplied
# example_3 = [
#   "deal with increment 7",
#   "deal with increment 9",
#   "cut -2",
# ]
# new_example_3 = [
#   "deal with increment 63",
#   "cut -2"
# ]
# (0..9).each do |i|
#   unless full_solve(new_example_3, 10, i) == example_3_solutions.find_index(i)
#     puts "postulate 2 fails for index #{i}"
#   end
# end

# # Also if (n * m) % length, correlary to postulate 2
# example_3 = [
#   "deal with increment 7",
#   "deal with increment 9",
#   "cut -2",
# ]
# new_example_3_simplified = [
#   "deal with increment 3",
#   "cut -2"
# ]
# (0..9).each do |i|
#   unless full_solve(new_example_3_simplified, 10, i) == example_3_solutions.find_index(i)
#     puts "postulate 2 fails for index #{i}"
#   end
# end