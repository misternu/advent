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

input = input.map { |row| row.map(&:to_i) }

# Part 1
a = 0
input.each do |row|
  sorted = row.sort
  next unless row == sorted || row == sorted.reverse
  unsafe = false
  (0...(row.length - 1)).each do |i|
    unsafe = true if row[i] == row[i + 1]
    unsafe = true if (row[i] - row[i + 1]).abs > 3
  end
  next if unsafe
  a += 1
end

# Part 2
b = 0
input.each do |row|
  sorted = row.sort
  unsafe = false
  unsafe = true unless row == sorted || row == sorted.reverse
  (0...(row.length - 1)).each do |i|
    unsafe = true if row[i] == row[i + 1]
    unsafe = true if (row[i] - row[i + 1]).abs > 3
  end
  if !unsafe
    b += 1
    next
  end
  saveable = false
  (0...(row.length)).each do |i|
    new_row = row.dup
    new_row.delete_at(i)
    new_sorted = new_row.sort
    next unless new_row == new_sorted || new_row == new_sorted.reverse
    unsafe = false
    (0...(new_row.length - 1)).each do |i|
      unsafe = true if new_row[i] == new_row[i + 1]
      unsafe = true if (new_row[i] - new_row[i + 1]).abs > 3
    end
    next if unsafe
    saveable = true
    break
  end
  b += 1 if saveable
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
