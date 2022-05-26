require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse


# Part 1 and 2
a = nil
index = 0
spoken = Hash[input.zip([*0...input.length])]
last = nil
neckst = input.count(input.last) - 1
(input.length...30000000).each do |i|
  last = neckst
  neckst = spoken.has_key?(last) ? i - spoken[last] : 0
  spoken[last] = i
  if i == 2019
    a = last
  end
end
b = last


helper.output(a, b)
