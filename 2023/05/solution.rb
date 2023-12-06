require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)


# input = sample_input

# Part 1
seeds, b, c, d, e, f, g, h = input.split("\n\n")

seeds = seeds.split(":").last.strip.split(" ").map(&:to_i)
b = b.split(":").last.strip.split("\n").map { |r| r.split(" ").map(&:to_i) }
c = c.split(":").last.strip.split("\n").map { |r| r.split(" ").map(&:to_i) }
d = d.split(":").last.strip.split("\n").map { |r| r.split(" ").map(&:to_i) }
e = e.split(":").last.strip.split("\n").map { |r| r.split(" ").map(&:to_i) }
f = f.split(":").last.strip.split("\n").map { |r| r.split(" ").map(&:to_i) }
g = g.split(":").last.strip.split("\n").map { |r| r.split(" ").map(&:to_i) }
h = h.split(":").last.strip.split("\n").map { |r| r.split(" ").map(&:to_i) }


locs = []
seeds.each do |seed|
  pos = seed

  [b, c, d, e, f, g, h].each do |m|
    m.each do |dest, src, len|
      if (src...(src+len)).include?(pos)
        pos = pos + (dest-src)
        break
      end
    end
  end

  locs << pos
end

a_out = locs.min

# Part 2
p2_seeds = seeds.each_slice(2)
min = Float::INFINITY
rs = [b, c, d, e, f, g, h]
maps = { b: {}, c: {}, d: {}, e: {}, f: {}, g: {}, h: {} }

(:b..:h).each_with_index do |sym, i|
  m = rs[i]
  m.each do |dest, src, len|
    diff = dest - src
    (src...(src+len)).each do |k|
      maps[sym][k] = k + diff
    end
  end
end

p maps.length

# p2_seeds.each do |st, len|
#   (st...(st+len)).each do |seed|
#     pos = seed

#     (:b..:h).each do |sym|
#       m = maps[sym]

#       pos = m[pos] || pos
#     end

#     min = [pos, min].min
#   end
# end

# p2_seeds.each do |st, len|
#   (st...(st+len)).each do |seed|
#     pos = seed

#     [b, c, d, e, f, g, h].each do |m|
#       m.each do |dest, src, len|
#         if (src...(src+len)).include?(pos)
#           pos = pos + (dest-src)
#           break
#         end
#       end
#     end
#     min = [pos, min].min
#   end
# end

b_out = min



# MemoryProfiler.stop.pretty_print
helper.output(a_out, b_out)
