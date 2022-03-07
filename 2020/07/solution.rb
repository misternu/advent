require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
# input = helper.auto_parse
input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')



# Part 1
outside = Hash.new { |h, k| h[k] = [] }
input.each do |sentence|
  outer_bag = sentence.match(/^(.*) bags contain/)[1]
  sentence.scan(/(?:contain|,) \d* (.*?) bag/).map(&:first).each do |inner|
    outside[inner] << outer_bag
  end
end

colors = []
queue = outside["shiny gold"]

while queue.any?
  color = queue.shift
  colors << color
  outer_bags = outside[color]
  queue.concat(outer_bags)
end

a = colors.uniq.length

# Part 2
inside = Hash.new { |h, k| h[k] = [] }
input.each do |sentence|
  outer_bag = sentence.match(/^(.*) bags contain/)[1]
  inner_bags = sentence.scan(/(?:contain|,) (.*? bag)/).map(&:first)
  next if inner_bags[0] == 'no other bag'
  inner_bags.each do |string|
    number, color = string.match(/(\d+) (.*) bag/)[1..2]
    inside[outer_bag] << [number.to_i, color]
  end
end

inventory = Hash.new(0)

queue = [[1, "shiny gold"]]

while queue.length > 0
  bag = queue.shift
  c, color = bag
  inventory[color] += c
  inside[color].each do |inside_bag|
    amount, color = inside_bag
    queue << [c * amount, color]
  end
end

inventory["shiny gold"] = 0

b = inventory.values.sum



helper.output(a, b)
