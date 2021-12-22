require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
input.map! { |l| l.split(' ') }
input.map! { |a, b| [a.to_sym, b.split(',').map { |r| r[2..-1].split('..').map(&:to_i) }] }



def overlap(a_ranges, b_ranges)
  (0...a_ranges.length).map do |i|
    return false if a_ranges[i][1] < b_ranges[i][0]
    return false if b_ranges[i][1] < a_ranges[i][0]
    [
      a_ranges[i][0] > b_ranges[i][0] ? a_ranges[i][0] : b_ranges[i][0],
      a_ranges[i][1] < b_ranges[i][1] ? a_ranges[i][1] : b_ranges[i][1]
    ]
  end
end

def volume(ranges)
  ranges.reduce(1) { |product, pair| product * (pair[1]-pair[0]+1) } 
end



# Part 1
init_range_boundary = (0...input[0][1].length).map { |x| [-50, 50] }
volumes = []
total = 0
input.each do |value, ranges|
  init_ranges = overlap(ranges, init_range_boundary)
  next unless init_ranges
  new_volumes = []
  volumes.each do |v_sign, v_ranges|
    if lap = overlap(init_ranges, v_ranges)
      new_volumes << [-v_sign, lap]
      total += volume(lap) * -v_sign
    end
  end
  if value == :on
    new_volumes << [1, ranges]
    total += volume(ranges)
  end
  volumes.concat(new_volumes)
end
a = total



# Part 2
volumes = []
total = 0
input.each do |value, ranges|
  new_volumes = []
  volumes.each do |v_sign, v_ranges|
    if lap = overlap(ranges, v_ranges)
      new_volumes << [-v_sign, lap]
      total += volume(lap) * -v_sign
    end
  end
  if value == :on
    new_volumes << [1, ranges]
    total += volume(ranges)
  end
  volumes.concat(new_volumes)
end
b = total



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
