require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

pairings = 1000

# input = sample_input
# pairings = 10

# Part 1
input = input.map { |l| l.map(&:to_i) }

def distance_squared(pos1, pos2)
  (0..2).sum do |i|
    (pos1[i] - pos2[i]).abs**2
  end
end

class UnionFind
  attr_reader :count

  def initialize(elements)
    @parent = {}
    @rank = Hash.new(0)
    @size = Hash.new(1)

    elements.each do |e|
      @parent[e] = e
    end

    @count = elements.length
  end

  def find(x)
    @parent[x] = find(@parent[x]) if @parent[x] != x
    @parent[x]
  end

  def union(x, y)
    root_x = find(x)
    root_y = find(y)

    return false if root_x == root_y

    if @rank[root_x] < @rank[root_y]
      @parent[root_x] = root_y
      @size[root_y] += @size[root_x]
    elsif @rank[root_x] > @rank[root_y]
      @parent[root_y] = root_x
      @size[root_x] += @size[root_y]
    else
      @parent[root_y] = root_x
      @size[root_x] += @size[root_y]
      @rank[root_x] += 1
    end

    @count -= 1
    true
  end

  def component_sizes
    @parent.keys.select { |n| @parent[n] == n }.map { |r| @size[r] }.sort.reverse
  end
end

uf = UnionFind.new((0...input.length).to_a)
pairs = (0...input.length).to_a.combination(2).sort_by do |n, m|
  distance_squared(input[n], input[m])
end

pairings.times do
  n, m = pairs.shift
  uf.union(n, m)
end

a = uf.component_sizes[0..2].reduce(&:*)

# part 2
last = nil
until uf.count == 1
  n, m = pairs.shift
  last = [n, m] if uf.union(n, m)
end

i, j = last
b = input[i][0] * input[j][0]

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
