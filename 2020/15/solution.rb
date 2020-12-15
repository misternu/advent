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
spoken = Hash.new { |h, k| h[k] = [] }
last = nil
input.each do |num|
  last = num
  spoken[num] << index
  index += 1
end
(2020 - input.length).times do
  indices = spoken[last]
  if indices.length == 1
    num = 0
    last = num
    spoken[num] << index
  else
    num = indices[-1] - indices[-2]
    last = num
    spoken[num] << index
  end
  index += 1
end
a = last

# Part 2
index = 0
spoken = Hash.new { |h, k| h[k] = [] }
last = nil
input.each do |num|
  last = num
  spoken[num] << index
  index += 1
end
(30000000 - input.length).times do
  indices = spoken[last]
  if indices.length == 1
    last = 0
    spoken[last] << index
  else
    last = indices[-1] - indices[-2]
    spoken[last] << index
  end
  index += 1
end
b = last



helper.output(a, b)
