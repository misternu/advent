require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
# input = helper.auto_parse
sample_input = helper.line_separated_strings('sample_input.txt')
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
height = input.length
width = input.first.length

nodes = {}
input.each_with_index do |row, y|
  row.split('').each_with_index do |col, x|
    if col != "."
      nodes[col] ||= {}
      nodes[col][[x, y]] = true
    end
  end
end

# Part 1
known = {}
nodes.keys.each do |key|
  (0...height).each do |y|
    (0...width).each do |x|
      nodes[key].keys.combination(2).each do |m, n|
        dx = (m[0] - n[0])
        dy = (m[1] - n[1])
        antinodes = [[m[0] + dx, m[1] + dy], [n[0] - dx, n[1] - dy]]
        antinodes.each do |an|
          known[an] = true if an[0] >= 0 && an[0] < width && an[1] >= 0 && an[1] < height
        end
      end
    end
  end
end
a = known.keys.length

# Part 2
known = {}
nodes.keys.each do |key|
  (0...height).each do |y|
    (0...width).each do |x|
      nodes[key].keys.combination(2).each do |m, n|
        known[m] = true
        known[n] = true
        dx = (m[0] - n[0])
        dy = (m[1] - n[1])
        i = 1
        loop do
          dm = [m[0] + (dx * i), m[1] + (dy * i)]
          break if dm[0].negative? || dm[0] >= width || dm[1].negative? || dm[1] >= height

          known[dm] = true
          i += 1
        end
        i = 1
        loop do
          dn = [n[0] - (dx * i), n[1] - (dy * i)]
          break if dn[0].negative? || dn[0] >= width || dn[1].negative? || dn[1] >= height

          known[dn] = true
          i += 1
        end
      end
    end
  end
end
b = known.keys.length

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
