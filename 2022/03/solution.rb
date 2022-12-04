require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)

input = helper.send(:open_file, 'input.txt').read
input = input.split("\n").map(&:chars)


# Part 1
priorities = {}
('a'..'z').each { |char| priorities[char] = char.ord - 96 }
('A'..'Z').each { |char| priorities[char] = char.ord - 38 }
a = input.sum do |rucksack|
  l = rucksack.length
  common = rucksack[0...(l/2)] & rucksack[(l/2)..]
  priorities[common.first]
end

# Part 2
b = input.each_slice(3).sum do |ch|
  common = ch.reduce(&:&)
  priorities[common.first]
end


helper.output(a, b)
# 00:17:33.15
