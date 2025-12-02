require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__)#, counter: false)
input = helper.comma_separated_strings('input.txt')
sample_input = helper.comma_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1 and 2
input = input.map { |l| l.split('-').map(&:to_i) }
a = 0
b = 0
input.each do |n, m|
  (n..m).each do |id|
    j = id.to_s
    mid = j.length / 2
    if j[0...mid] == j[mid..]
      a += id
      b += id
    else
      chars = j.chars
      (1..mid).each do |i|
        if chars.rotate(i).join == j
          b += id
          break
        end
      end
    end
  end
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
