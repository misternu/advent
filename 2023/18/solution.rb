require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
pos = [0,0]
map = {}
dirs = { 
  "U" => [0,-1],
  "R" => [1,0],
  "D" => [0,1],
  "L" => [-1,0]
}

input.each do |instruction|
  dir, dist, color = instruction
  dist = dist.to_i
  dx, dy = dirs[dir]
  x, y = pos
  (0..dist).each do |os|
    map[[x + (os * dx), y + (os * dy)]] = true
  end
  pos = [x + (dist * dx), y + (dist * dy)]
end

def print_map(map)
  keys = map.keys
  xs = keys.map { |k| k[0] }
  ys = keys.map { |k| k[1] }
  left = xs.min
  right = xs.max
  top = ys.min
  bottom = ys.max

  (top..bottom).each do |y|
    line = (left..right).map do |x|
      if map[[x,y]]
        "#"
      else
        ' '
      end
    end

    puts line.join
  end
end

def neighbors(map, x, y)
  [[0,-1],[1,0],[0,1],[-1,0]].map do |dx, dy|
    [x + dx, y + dy]
  end
end

def count_map(map)
  keys = map.keys
  xs = keys.map { |k| k[0] }
  ys = keys.map { |k| k[1] }
  left = xs.min
  right = xs.max
  top = ys.min
  bottom = ys.max

  inside = nil
  (top..bottom).each do |y|
    (left..right).each do |x|
      if map[[x,y]] && map[[x+1,y]] && map[[x,y+1]] && !map[[x+1,y+1]]
        inside = [x+1, y+1]
      end
      break if inside
    end
    break if inside
  end

  dug = { inside => true }
  queue = [inside]

  until queue.empty?
    h = queue.shift
    x, y = h
    if x < left || y < top || x > right || y > bottom
      return false
    end
    dug[h] = true
    ns = neighbors(map, h[0], h[1])
    queue = queue + ns.reject { |pos| dug[pos] || map[pos] }
    queue = queue.uniq
  end
  map.keys.count + dug.keys.count
end

a = count_map(map)

# Part 2
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
