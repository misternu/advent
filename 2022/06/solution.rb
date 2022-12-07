require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
chars = input.chars


# Part 1
a = nil
(3...chars.length).each do |i|
  if chars[(i-3)..i].uniq.length == 4
    a = i + 1
    break
  end
end

# Part 2
b = nil
(13...chars.length).each do |i|
  if chars[(i-13)..i].uniq.length == 14
    b = i + 1
    break
  end
end


# MemoryProfiler.stop.pretty_print
helper.output(a, b)
