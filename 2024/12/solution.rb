require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')

# input = sample_input
height = input.length
width = input.first.length

# Part 1
DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze
def neighbors(pos)
  DIRS.map do |dx, dy|
    [pos[0] + dx, pos[1] + dy]
  end
end

taken = {}
a = 0
(0...height).each do |y|
  (0...width).each do |x|
    next if taken[[x, y]]

    area = 0
    perimeter = 0
    value = input[y][x]
    queue = [[x, y]]
    searched = {}
    until queue.empty?
      pos = queue.shift
      next if searched[pos]

      taken[pos] = true
      searched[pos] = true
      area += 1
      neighbors(pos).each do |n|
        if n[0] < 0 || n[1] < 0 || n[0] >= width || n[1] >= height
          perimeter += 1
          next
        end

        n_value = input[n[1]][n[0]]
        if n_value != value
          perimeter += 1
        else
          queue << n
        end
      end
    end

    a += area * perimeter
  end
end

# Part 2
taken = {}
b = 0
(0...height).each do |y|
  (0...width).each do |x|
    next if taken[[x, y]]

    area = 0
    value = input[y][x]
    pos = [x, y]
    queue = [pos]
    searched = {}
    edges = { 0 => {}, 1 => {}, 2 => {}, 3 => {} }
    until queue.empty?
      pos = queue.shift
      next if searched[pos]

      taken[pos] = true
      searched[pos] = true
      area += 1

      DIRS.each_with_index do |dir, i|
        n = [pos[0] + dir[0], pos[1] + dir[1]]
        if n[0] < 0 || n[1] < 0 || n[0] >= width || n[1] >= height
          edges[i][n] = true
          next
        end

        n_value = input[n[1]][n[0]]
        if n_value != value
          edges[i][n] = true
          next
        end

        queue << n
      end
    end

    sides = 0
    # up down
    [0, 2].each do |d|
      searched = {}
      edges[d].keys.each do |pos|
        next if searched[pos]

        queue = [pos]
        until queue.empty?
          m = queue.shift
          next if searched[m]
          searched[m] = true
          [[m[0] + 1, m[1]], [m[0] - 1, m[1]]].each do |dir|
            if edges[d][dir]
              queue << dir
            end
          end
        end
        sides += 1
      end
    end

    # left right
    [1, 3].each do |d|
      searched = {}
      edges[d].keys.each do |pos|
        next if searched[pos]

        queue = [pos]
        until queue.empty?
          m = queue.shift
          next if searched[m]
          searched[m] = true
          [[m[0], m[1] + 1], [m[0], m[1] - 1]].each do |dir|
            if edges[d][dir]
              queue << dir
            end
          end
        end
        sides += 1
      end
    end

    b += area * sides
  end
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
