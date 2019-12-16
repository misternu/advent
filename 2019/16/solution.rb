require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

def pattern_enumerator(n)
  base_pattern = [0, 1, 0, -1]
  Enumerator.new do |enum|
    pattern = base_pattern.map { |i| [i] * n } .flatten

    pattern[1..-1].each do |i|
      enum << i
    end
    while true
      pattern.each do |i|
        enum << i
      end
    end
  end
end

input = helper.line_separated_strings('input.txt').first.split('').map(&:to_i)

# Part 1
digits = input.dup
(1..100).each do |iteration|
  (1..digits.length).each do |n|
    digits[n-1] = digits.dup.zip(pattern_enumerator(n)).map { |a, b| (a * b)} .sum.abs % 10
  end
end
puts digits[0...8].map(&:to_s).join

# Part 2
# digits = "03036732577212944063491565474664".split('').map(&:to_i) * 10000
digits = input * 10000
offset = digits[0..6].map(&:to_s).join.to_i
chopped_digits = digits[offset..-1]
(1..100).each do |phase|
  new_digits = []
  running_sum = 0
  chopped_digits.reverse.each do |n|
    running_sum = (running_sum + n) % 10
    new_digits << running_sum
  end
  chopped_digits = new_digits.reverse
end
puts chopped_digits[0...8].map(&:to_s).join
