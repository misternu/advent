require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]

# Part 1
digits = input.map(&:chars).transpose
gamma = digits.map { |d| d.count("1") > input.length/2 ? "1" : "0" } .join.to_i(2)
# "111111111111" == 4095
a = gamma * (4095 - gamma)

# Part 2
def scrub(input, o: true, i: 0)
  return input.first.to_i(2) if input.length == 1
  digits = input.map { |v| v[i] }
  keep = (digits.count("0") > digits.length / 2) == o ? "0" : "1"
  scrub(input.select { |v| v[i] == keep }, o: o, i: i+1)
end
b = scrub(input) * scrub(input, o: false)

helper.output(a, b)
