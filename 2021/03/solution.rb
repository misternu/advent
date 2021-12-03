require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
# input = helper.auto_parse
input = helper.line_separated_strings('input.txt')
sample_input = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]

# Part 1
digits = Hash.new { |h, k| h[k] = [0, 0] }
input.each do |line|
  line.split('').each_with_index do |c, i|
    if c == "1"
      digits[i][0] += 1
    else
      digits[i][1] += 1
    end
  end
end
gamma = (0...12).map { |i| digits[i][0] > digits[i][1] ? "1" : "0"} .join.to_i(2)
epsilon = (0...12).map { |i| digits[i][0] < digits[i][1] ? "1" : "0"} .join.to_i(2)
a = gamma * epsilon

# Part 2
indexed = input.each_with_index.map { |v, i| [i, v] }
# oxy
values = input.each_with_index.map { |v, i| [i, v] }
until values.length == 1
  counts = { "0" =>  0, "1" => 0}
  values.each do |i, v|
    if v.chars.first == "1"
      counts["1"] += 1
    else
      counts["0"] += 1
    end
  end
  if counts["0"] > counts["1"]
    # keep all that start with 0
    values = values.select { |i, v| v.chars.first == "0" }
  else
    values = values.select { |i, v| v.chars.first == "1" }
  end
  values = values.map { |i, v| [i, v[1..-1]] }
end
oxy = input[values.first.first].to_i(2)
# co
values = input.each_with_index.map { |v, i| [i, v] }
until values.length == 1
  counts = { "0" =>  0, "1" => 0}
  values.each do |i, v|
    if v.chars.first == "1"
      counts["1"] += 1
    else
      counts["0"] += 1
    end
  end
  if counts["1"] < counts["0"]
    # keep all that start with 0
    values = values.select { |i, v| v.chars.first == "1" }
  else
    values = values.select { |i, v| v.chars.first == "0" }
  end
  values = values.map { |i, v| [i, v[1..-1]] }
end
co = input[values.first.first].to_i(2)
b = oxy * co

helper.output(a, b)
