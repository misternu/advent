require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
# input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
rows = input.dup.map { |l| l.scan(/mul\(\d{1,3},\d{1,3}\)/) }
a = 0

rows.flatten.each do |mult|
  a += mult.scan(/\d{1,3}/).map(&:to_i).reduce(&:*)
end

# Part 2
rows = input.dup.map do |l|
  l.scan(/(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/)
end

b = 0
enabled = true

rows.flatten.each do |instr|
  if instr == "do()"
    enabled = true
  elsif instr == "don't()"
    enabled = false
  elsif enabled
    b += instr.scan(/\d{1,3}/).map(&:to_i).reduce(&:*)
  end
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
