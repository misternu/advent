require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
ranges, ids = input.split("\n\n")
ranges = ranges.split("\n").map { |r| r.split("-").map(&:to_i) }
ids = ids.split("\n").map(&:to_i)
a = ids.count { |id| ranges.any? { |i, j| (i..j).cover?(id) } }

# Part 2
ranges = ranges.map { |pair| Range.new(*pair) }
ranges.sort_by!(&:begin)

merged = [ranges[0]]
(1...ranges.length).each do |i|
  last = merged.last

  if ranges[i].begin <= last.end + 1
    new_end = [last.end, ranges[i].end].max
    merged[-1] = (last.begin..new_end)
  else
    merged << ranges[i]
  end
end

b = merged.sum { |range| range.end - range.begin + 1 }

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
