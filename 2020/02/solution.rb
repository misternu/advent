require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, script_file: __FILE__)
input = helper.auto_parse



# Part 1
# 546
a = input.count do |values|
  low, high, char, password = values
  repetition = password.split('').count { |letter| letter == char }
  repetition >= low.to_i && repetition <= high.to_i
end

# Part 2
# 275
b = input.count do |values|
  low, high, char, password = values
  (password[low.to_i - 1] == char) != (password[high.to_i - 1] == char)
end



helper.output(a, b)
