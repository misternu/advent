require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

conn = Hash.new { |h, k| h[k] = Set.new }

input.each do |m, n|
  conn[m].add(n)
  conn[n].add(m)
end

triplets = Set.new

conn.keys.each do |user|
  conn[user].to_a.combination(2) do |m, n|
    triplets.add([user, m, n].sort) if conn[m].include?(n)
  end
end

# Part 1
a = triplets.to_a.sort.count { |array| array.any? { |s| s[0] == 't' } }

# Part 2
parties = Set.new

def party?(group, conn)
  return true if group.length == 1

  user = group[0]
  others = group[1..]

  others.all? { |n| conn[user].include?(n) } && party?(others, conn)
end

conn.each_key do |user|
  num = conn[user].length
  num.downto(1).each do |size|
    groups = conn[user].to_a.combination(size).select do |group|
      party?(group, conn)
    end

    if groups.length.positive?
      parties.add(([user] + groups.first).sort)
      break
    end
  end
end

b = parties.max_by(&:length).join(",")

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
