require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]

# Part 1
digits = input.map(&:chars).transpose
thresh = input.length/2
gamma = digits.map { |d| d.count("1") > thresh ? "1" : "0" } .join.to_i(2)
delta = digits.map { |d| d.count("1") < thresh ? "1" : "0" } .join.to_i(2)
a = gamma * delta

# Part 2
oxy = input.dup
i = 0
while oxy.compact.length > 1
  digits = oxy.compact.map { |line| line[i] }
  num = digits.count("0") > digits.length / 2 ? "0" : "1"
  oxy = oxy.each_with_index.map { |line, j| input[j][i] == num ? line : nil }
  i += 1
end
o = oxy.compact.last.to_i(2)

co = input.dup
i = 0
while co.compact.length > 1
  digits = co.compact.map { |line| line[i] }
  num = digits.count("0") > digits.length / 2 ? "1" : "0"
  co = co.each_with_index.map { |line, j| input[j][i] == num ? line : nil }
  i += 1
end
c = co.compact.last.to_i(2)

b = o * c


helper.output(a, b)
