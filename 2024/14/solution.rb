require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')

# input = sample_input
input = input.map { |l| l.scan(/[\d-]+/).map(&:to_i) }
width = 101
height = 103
# width = 11
# height = 7
vert = width / 2
hori = height / 2

# Part 1
bots = []
input.each do |x, y, dx, dy|
  bots << [[x, y], [dx, dy]]
end

100.times do
  new_bots = []

  bots.each do |pos, vec|
    new_bots << [[(pos[0] + vec[0]) % width, (pos[1] + vec[1]) % height], vec]
  end

  bots = new_bots
end

quads = [0, 0, 0, 0]
bots.each do |pos, vec|
  if pos[0] < vert
    if pos[1] < hori
      quads[0] += 1
    elsif pos[1] > hori
      quads[2] += 1
    end
  elsif pos[0] > vert
    if pos[1] < hori
      quads[1] += 1
    elsif pos[1] > hori
      quads[3] += 1
    end
  end
end

a = quads.reduce(&:*)

# Part 2
bots = []
input.each do |x, y, dx, dy|
  bots << [[x, y], [dx, dy]]
end

b = 0
(1...1_000_000_000).each do |i|
  new_bots = []

  bots.each do |pos, vec|
    new_bots << [[(pos[0] + vec[0]) % width, (pos[1] + vec[1]) % height], vec]
  end

  bots = new_bots

  # line_counts = (0...height).map { |y| bots.count { |q, v| q[1] == y } }
  # col_counts = (0...width).map { |x| bots.count { |q, v| q[1] == x } }
  # unless line_counts.any? { |v| v > 33 } || col_counts.any? { |v| v > 33 }
  #   b += 1
  #   next
  # end

  # img = Hash.new(0)
  # bots.each do |p, v|
  #   img[p] += 1
  # end

  quads = []
  quads << bots.count { |p, v| p[0] < vert && p[1] < hori }
  quads << bots.count { |p, v| p[0] < vert && p[1] > hori }
  quads << bots.count { |p, v| p[0] > vert && p[1] < hori }
  quads << bots.count { |p, v| p[0] > vert && p[1] > hori }

  if quads.reduce(&:*) < 80_000_000
    b = i
    break
  end

  # lines = (0...height).map do |y|
  #   line = (0...width).map do |x|
  #     count = img[[x, y]]
  #     if count.zero?
  #       "."
  #     else
  #       count.to_s
  #     end
  #   end
  #   line.join
  # end
  # puts lines.join("\n")

  # input = gets
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
