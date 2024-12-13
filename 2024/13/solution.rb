require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read

# input = sample_input

input = input.split("\n\n").map do |l|
  l.split("\n").map { |q| q.scan(/(\d+)/).flatten.map(&:to_i) }
end
# Part 1
a = 0
input.each do |button|
  da, db, dest = button
  da_x, da_y = da
  db_x, db_y = db
  dest_x, dest_y = dest

  total = 0
  (0..100).each do |push_a|
    next unless (dest_x - (da_x * push_a)) % db_x == 0
    push_b = (dest_x - (da_x * push_a)) / db_x
    next unless (dest_y - (da_y * push_a)) / db_y == push_b
    next unless push_b <= 101

    total += push_a * 3
    total += push_b * 1
    break
  end
  a += total
end

# Part 2
b = 0
input.each do |button|
  qa, qb, dest = button
  ax, ay = qa
  bx, by = qb
  cx, cy = dest
  cx += 10000000000000
  cy += 10000000000000

  # cramer's rule
  # ax * a + bx * b = cx
  # ay * a + by * b = cy

  # d = |ax bx| d_a = |cx bx| d_b = |ax cx|
  #     |ay by|       |cy by|       |ay cy|

  d = (ax * by) - (bx * ay)
  next if d.zero?
  d_a = (cx * by - cy * bx) / d.to_f
  next unless d_a == d_a.to_i && d_a.positive?
  d_b = (ax * cy - ay * cx) / d.to_f
  next unless d_b == d_b.to_i && d_b.positive?

  b += (3 * d_a.to_i) + d_b.to_i
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
