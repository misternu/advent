require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
input.map! { |l| l.split(' ') }
input.map! { |a, b| [a] + b.split(',').map { |r| r[2..-1].split('..').map(&:to_i) } }



# Part 1
values = Hash.new
input.each do |value, x_values, y_values, z_values|
  x_range = ([x_values.first, -50].max..[x_values.last, 50].min)
  y_range = ([y_values.first, -50].max..[y_values.last, 50].min)
  z_range = ([z_values.first, -50].max..[z_values.last, 50].min)
  x_range.each do |x|
    y_range.each do |y|
      z_range.each do |z|
        values[[x,y,z]] = value == "on"
      end
    end
  end
end
a = (-50..50).sum do |x|
  (-50..50).sum do |y|
    (-50..50).count do |z|
      values[[x,y,z]]
    end
  end
end

# Part 2
def overlap(a_ranges, b_ranges)
  (0..2).map do |i|
    a_range = a_ranges[i]
    b_range = b_ranges[i]
    return false if a_range.last < b_range.first
    return false if b_range.last < a_range.first
    [
      a_range.first > b_range.first ? a_range.first : b_range.first,
      a_range.last < b_range.last ? a_range.last : b_range.last
    ]
  end
end

def volume(ranges)
  ranges.reduce(1) { |product, pair| product * (pair.last-pair.first+1) } 
end

volumes = []
total = 0
input.each do |value, x, y, z|
  ranges = [x, y, z]
  new_volumes = []
  volumes.each do |v_sign, v_ranges|
    if lap = overlap(ranges, v_ranges)
      new_volumes << [-v_sign, lap]
      total += volume(lap) * -v_sign
    end
  end
  if value == "on"
    new_volumes << [1, ranges]
    total += volume(ranges)
  end
  volumes.concat(new_volumes)
end
b = total



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
