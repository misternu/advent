require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)


# input = sample_input

# Part 1
input = input.map { |r| r.split(" ").map(&:to_i) }

a = input.sum do |hist|
  rows = [hist.dup]
  until rows.last.all? { |v| v == 0 }
    new_row = (0...rows.last.length - 1).map do |i|
      rows.last[i+1] - rows.last[i]
    end
    break if new_row.empty?
    rows << new_row
  end
  rows.map(&:last).sum
end

# Part 2
b = input.sum do |hist|
  rows = [hist.dup]
  until rows.last.all? { |v| v == 0 }
    new_row = (0...rows.last.length - 1).map do |i|
      rows.last[i+1] - rows.last[i]
    end
    break if new_row.empty?
    rows << new_row
  end

  firsts = rows.map(&:first).reverse
  firsts.reduce do |acc, n|
    n - acc
  end
end



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
