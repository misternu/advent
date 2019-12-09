require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

width = 25
height = 6

input = helper.plain_string('input.txt').read

layers = input.chomp.scan(/.{#{width * height}}/).map do |layer|
  layer.split('').map(&:to_i)
end

# Part 1
layer = layers.min_by { |l| l.count(0) }
ones = layer.count(1)
twos = layer.count(2)
p ones * twos

# Part 2
pixels = layers.transpose
pixels.map! do |pixel|
  pixel.find { |p| p != 2}
end

pixels.each_slice(width) do |row|
  puts row.map { |p| p == 1 ? '#' : ' ' }.join
end