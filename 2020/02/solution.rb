require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')



# Part 1
re = /(\d+)-(\d+) (.): (\S+)$/
a = input.count do |value|
  matches = re.match(value)[1..-1]
  low = matches[0].to_i
  high = matches[1].to_i
  char = matches[2]
  password = matches[3]

  repetition = password.split('').count { |letter| letter == char }
  repetition >= low && repetition <= high
end

# Part 2
b = input.count do |value|
  matches = re.match(value)[1..-1]
  low = matches[0].to_i
  high = matches[1].to_i
  char = matches[2]
  password = matches[3]

  (password[low - 1] == char) != (password[high - 1] == char)
end



helper.output(a, b)
