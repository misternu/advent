# based on https://github.com/BedfordWest/advent2020/blob/main/src/day10/solution.js
require 'benchmark'
require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, clear: false)
input = helper.auto_parse.sort!


def path_for(num)
  return 1 if num < 3
  jumps = [1,2,3].select { |n| n < num }
  jumps.map { |n| path_for(num - n) }.sum
end

# save all the path counts for 1 to 10
paths = Hash.new
(1..10).each do |n|
  paths[n] = path_for(n)
end

groups = []
i = 0
last = 0
group = 1
while true
  if input[i] - last == 1
    group += 1
  else
    groups << group
    group = 1
  end

  last = input[i]
  i += 1

  unless i < input.length
    groups << group
    break
  end
end

p groups.map { |n| paths[n] } .reduce(&:*)



# benchmark solving 1000 times
puts Benchmark.measure {
  1000.times do
    groups = []
    i = 0
    last = 0
    group = 1
    while true
      if input[i] - last == 1
        group += 1
      else
        groups << group
        group = 1
      end

      last = input[i]
      i += 1

      unless i < input.length
        groups << group
        break
      end
    end

    groups.map { |n| paths[n] } .reduce(&:*)
  end
}