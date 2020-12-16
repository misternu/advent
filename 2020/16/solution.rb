require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.open_file('input.txt').read
# input = helper.open_file('sample_input.txt').read
parameters, ticket, nearby = input.split("\n\n")
parameters = parameters.split("\n").map { |line| /(.*): (\d+)-(\d+) or (\d+)-(\d+)/.match(line)[1..-1] }
ticket = ticket.split("\n").last.split(',').map(&:to_i)
nearby = nearby.split("\n")[1..-1].map { |line| line.split(',').map(&:to_i) }

# Part 1
valid = Hash.new
parameters.each do |name, a, b, x, y|
  a, b, x, y = [a, b, x, y].map(&:to_i)
  (a..b).each do |i|
    valid[i] = true
  end
  (x..y).each do |i|
    valid[i] = true
  end
end
invalid = []
invalid_indexes = Hash.new
nearby.each_with_index do |t, index|
  t.each do |value|
    if !valid[value]
      invalid << value
      invalid_indexes[index] = true
    end
  end
end
a = invalid.sum

# Part 2
rules = Hash.new
parameters.each do |name, a, b, x, y|
  a, b, x, y = [a, b, x, y].map(&:to_i)
  rules[name] = -> (i) { (i >= a && i <= b) || (i >= x && i <= y) }
end
possible_orders = Hash.new
valid_nearby = nearby.each_with_index.reject do |t, i|
  invalid_indexes[i]
end .map(&:first)
rules.each do |name, rule|
  indices = (0...ticket.length).find_all do |i|
    valid_nearby.all? do |t|
      rule.call(t[i])
    end
  end
  possible_orders[name] = indices
end

orders = Hash.new
while possible_orders.values.any? { |v| v.length > 1 }
  (0...ticket.length).each do |i|
    count = possible_orders.values.count { |v| v.include?(i) }
    if count == 1
      rule = possible_orders.find { |k, v| v.include?(i) }
      orders[i] = rule.first
      possible_orders.delete(rule.first)
    end
  end
end

my_ticket = []
orders.each do |index, name|
  if /departure/ =~ name
    my_ticket << ticket[index]
  end
end

b = my_ticket.reduce(&:*)



helper.output(a, b)
