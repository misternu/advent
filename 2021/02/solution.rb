require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse

# Part 1
pairs = input.map { |a, b| [a, b.to_i] }
pos = [0,0]

pairs.each do |dir, n|
  case dir
  when 'up'
    pos[1] += n
  when 'down'
    pos[1] -= n
  when 'forward'
    pos[0] += n
  end
end

a = pos[0] * pos[1]

# Part 2

pos = [0,0]
aim = 0

pairs.each do |dir, n|
  p pos
  p aim
  case dir
  when 'up'
    # pos[1] += n
    aim -= n
  when 'down'
    # pos[1] -= n
    aim += n
  when 'forward'
    pos[0] += n
    pos[1] += aim * n
  end
end
b = pos[0] * pos[1]

helper.output(a, b)
