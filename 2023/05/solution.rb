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
seeds = seeds.each_slice(2).map { |s, l| (s...s+l) }
rs = [b, c, d, e, f, g, h]
maps = {}

(:b..:h).each_with_index do |sym, i|
  m = rs[i]
  maps[i] = {}
  m.each do |dest, src, len|
    maps[i][(src...(src+len))] = dest - src
  end
end

def intersection(a, b)
  return nil if a.end < b.begin || b.end < a.begin
  [a.begin, b.begin].max..[a.end, b.end].min
end

def complements(a, b)
  result = []

  if a.begin < b.begin
    result << (a.begin..b.begin-1)
  end

  if a.end > b.end
    result << (b.end+1..a.end)
  end

  result
end

def dig(maps, r, i = 0)
  return [r] unless maps[i]

  range_diff = maps[i].find { |k,v| intersection(k, r) }
  return dig(maps, r, i+1) unless range_diff

  range, diff = range_diff
  sect = intersection(range, r)
  comps = complements(r, range).flat_map { |dr| dig(maps, dr, i) }
  comps + dig(maps, (sect.begin+diff..sect.end+diff), i+1)
end


b_out = seeds.flat_map { |range| dig(maps, range) } .map(&:begin).min



# MemoryProfiler.stop.pretty_print
helper.output(a_out, b_out)
