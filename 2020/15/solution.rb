require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse


# Part 1 and 2
a = nil
index = 0
spoken = []
input.each_with_index do |n, i|
  spoken[n] = i
end
last = nil
neckst = 0
(input.length...30000000).each do |i|
  last = neckst
  neckst = spoken[last] ? i - spoken[last] : 0
  spoken[last] = i
  if i == 2019
    a = last
  end
end
b = last


helper.output(a, b)
