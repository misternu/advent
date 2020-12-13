require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



# Part 1
start = input.first.first.to_i.dup
a = nil
timestamp = input.first.first.to_i
while true
  available = input.last.select do |bus|
    bus != 'x' && timestamp % bus.to_i == 0
  end
  if available.length > 0
    a = available.first.to_i
    break
  end
  timestamp += 1
end
a = a * (timestamp - start)

# Part 2
target = Hash.new
input.last.each_with_index do |bus, index|
  next if bus == 'x'
  target[bus.to_i] = index
end

buses = target.keys
total = buses.first

buses[1..-1].each_with_index do |bus, i|
  co = 0
  prod = buses[0..i].reduce(&:*)
  while true
    new_total = total + prod * co
    if (new_total + target[bus]) % bus == 0
      total = new_total
      break
    end
    co += 1
  end
end

b = total



helper.output(a, b)
