require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

min = 130254
max = 678275

def has_repeat(digits)
  (0...digits.length-1).any? do |i|
    digits[i] == digits[i + 1]
  end
end

def ascends(digits)
  (0...digits.length-1).all? do |i|
    digits[i] >= digits[i + 1]
  end
end

def has_a_double(digits)
  (0...digits.length-1).any? do |i|
    digits[i] == digits[i + 1] && digits.count(digits[i]) == 2
  end
end

range = (min..max)
part1 = 0
part2 = 0

range.each do |num|
  digits = num.digits
  if ascends(digits)
    part1 += 1 if has_repeat(digits)
    part2 += 1 if has_a_double(digits)
  end
end

p part1
p part2
