require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
input = input.map { |row| row.split('') }
row_count = input.length
col_count = input.first.length
a = 0
input.each { |row| a += row.join.scan(/(?=XMAS|SAMX)/).length }
input.transpose.each { |row| a += row.join.scan(/(?=XMAS|SAMX)/).length }
slant_right = input.each_with_index.map do |row, i|
  ([' '] * (col_count - i - 1)) + row + ([' '] * i)
end
slant_left = input.each_with_index.map do |row, i|
  ([' '] * i) + row + ([' '] * (col_count - i - 1))
end
slant_right.transpose.each { |row| a += row.join.scan(/(?=XMAS|SAMX)/).length }
slant_left.transpose.each { |row| a += row.join.scan(/(?=XMAS|SAMX)/).length }

# Part 2
b = 0

(1...row_count - 1).each do |y|
  (1...col_count - 1).each do |x|
    next unless input[y][x] == "A"
    next unless "SM".include?(input[y - 1][x - 1])
    next unless "SM".include?(input[y - 1][x + 1])
    next unless "SM".include?(input[y + 1][x - 1])
    next unless "SM".include?(input[y + 1][x + 1])
    next unless input[y - 1][x - 1] != input[y + 1][x + 1]
    next unless input[y - 1][x + 1] != input[y + 1][x - 1]

    b += 1
  end
end
# MemoryProfiler.stop.pretty_print
helper.output(a, b)
