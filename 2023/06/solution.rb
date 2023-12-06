require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)


# input = sample_input

# Part 1
times = input.first[1..-1].map(&:to_i)
dists = input.last[1..-1].map(&:to_i)

races = (0...times.length).map do |i|
  time, dist = times[i], dists[i]

  (1...time).count do |v|
    v * (time - v) > dist
  end
end

a = races.reduce(&:*)

# Part 2
time = input.first[1..-1].join.to_i
dist = input.last[1..-1].join.to_i

count = (1...time).count do |v|
  v * (time - v) > dist
end

b = count



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
