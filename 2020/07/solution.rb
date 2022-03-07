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
  sentence.scan(/(?:contain|,) \d* (.*?) bag/).each do |inner|
    outside[inner.first] << outer_bag
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
inside = Hash.new([])

input.each do |sentence|
  outer_bag = sentence.match(/^(.*) bags contain/)[1]
  inner_bags = sentence.scan(/(contain|,) (.*? bag)/).map { |pair| pair.last }
  if inner_bags.first != 'no other bag'
    inner_bags.map! { |b| b.match(/(\d+) (.*) bag/)[1..2] }
    inner_bags.each do |inner|
      number, color = inner.first.to_i, inner.last
      inside[outer_bag] += [[number, color]]
    end
  end
end

inventory = Hash.new(0)

queue = [[1, "shiny gold"]]

while queue.length > 0
  bag = queue.shift
  inventory[bag.last] += bag.first
  insides = inside[bag.last].map { |i| [i.first * bag.first, i.last] }
  queue += insides
end

b = inventory.values.sum - 1



helper.output(a, b)
