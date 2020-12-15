require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



# Part 1
index = 0
spoken = Hash[input.zip([*0...input.length])]
last = nil
neckst = input.count(input.last) - 1
(input.length...2020).each do |i|
  last = neckst
  neckst = spoken[last] ? i - spoken[last] : 0
  spoken[last] = i
end
a = last

# Part 2
index = 0
spoken = Hash[input.zip([*0...input.length])]
last = nil
neckst = input.count(input.last) - 1
(input.length...30000000).each do |i|
  last = neckst
  neckst = spoken[last] ? i - spoken[last] : 0
  spoken[last] = i
end
b = last



helper.output(a, b)
