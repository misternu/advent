require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')



# Part 1
parameter = 25
i = (parameter...input.length).find do |i|
  input[i-parameter..i-1].combination(2).none? { |a,b| a + b == input[i] }
end
a = input[i]

# Part 2
b = nil
(0...input.length-1).each do |i|
  (i+1...input.length).each do |j|
    sum = input[i..j].sum
    break if sum > a
    if sum == a
      b = input[i..j].min + input[i..j].max
    end
  end
end



helper.output(a, b)
