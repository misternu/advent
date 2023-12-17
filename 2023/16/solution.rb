require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.send(:open_file, 'sample_input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1

map = input.map { |l| l.split('') }

# urdl

# def print_map(map, path)
#   (0...map.length).each do |y|
#     line = (0...map.first.length).map do |x|
#       if path[[x,y]].any?
#         "#"
#       else
#         map[y][x]
#       end
#     end
#     puts line.join
#   end
# end

def test_beam(map, start_beam)
  beams = [start_beam.dup]
  path = Hash.new { |h,k| h[k] = [false, false, false, false] }

  while true
    beam = beams.shift
    break unless beam

    x, y, dx, dy = beam

    if path[[x,y]].any?
      up, ri, dn, le = path[[x,y]]
      next if dy == 1 && up
      next if dx == -1 && ri
      next if dy == -1 && dn
      next if dx == 1 && le
    end

    path[[x,y]][0] ||= dy == 1
    path[[x,y]][1] ||= dx == -1
    path[[x,y]][2] ||= dy == -1
    path[[x,y]][3] ||= dx == 1


    case map[y][x]
    when "\\"
      if dy == 1
        path[[x,y]][1] = true
        beams << [x+1,y,1,0] if x+1 < map.first.length
      elsif dx == -1
        path[[x,y]][0] = true
        beams << [x,y-1,0,-1] if y-1 > 0
      elsif dy == -1
        path[[x,y]][3] = true
        beams << [x-1,y,-1,0] if x-1 > 0
      elsif dx == 1
        path[[x,y]][2] = true
        beams << [x,y+1,0,1] if y+1 < map.length
      end
      next
    when "/"
      if dy == 1
        path[[x,y]][3] = true
        beams << [x-1,y,-1,0] if x-1 >= 0
      elsif dx == -1
        path[[x,y]][2] = true
        beams << [x,y+1,0,1] if y+1 < map.length
      elsif dy == -1
        path[[x,y]][1] = true
        beams << [x+1,y,1,0] if x+1 < map.first.length
      elsif dx == 1
        path[[x,y]][0] = true
        beams << [x,y-1,0,-1] if y-1 >= 0
      end
      next
    when "|"
      if dx == 1 || dx == -1
        new_beams = []
        if y-1 >= 0
          new_beams << [x, y-1, 0, -1]
          path[[x,y]][0] = true
        end
        if y+1 < map.length
          new_beams << [x, y+1, 0, 1]
          path[[x,y]][2] = true
        end
        beams = beams + new_beams
        next
      else
        path[[x,y]][0] = true if dy == -1
        path[[x,y]][2] = true if dy == 1
        y += dy
        beams << [x, y, dx, dy] if y >= 0 && y < map.length
        next
      end
    when "-"
      if dy == 1 || dy == -1
        new_beams = []
        if x-1 >= 0
          new_beams << [x-1, y, -1, 0]
          path[[x,y]][3] = true
        end
        if x+1 < map.first.length
          new_beams << [x+1, y, 1, 0]
          path[[x,y]][1] = true
        end
        beams = beams + new_beams
        next
      else
        path[[x,y]][3] ||= dx == -1
        path[[x,y]][1] ||= dx == 1
        x += dx
        beams << [x, y, dx, dy] if x >= 0 && x < map.first.length
        next
      end
    else
      path[[x,y]][0] ||= dy == -1 
      path[[x,y]][1] ||= dx == 1
      path[[x,y]][2] ||= dy == 1
      path[[x,y]][3] ||= dx == -1
      x, y = x + dx, y + dy
      beams << [x, y, dx, dy] if x >= 0 && x < map.first.length && y >= 0 && y < map.length
    end
  end

  path.values.count { |v| v.any? }
end

a = test_beam(map, [0,0,1,0])

# Part 2

max = 0

(0...map.first.length).each do |x|
  energy = test_beam(map, [x,0,0,1])
  max = [max, energy].max

  energy = test_beam(map, [x,map.length-1,0,-1])
  max = [max, energy].max
end

(0...map.length).each do |y|
  energy = test_beam(map, [0,y,1,0])
  max = [max, energy].max

  energy = test_beam(map, [map.first.length-1,y,-1,0])
  max = [max, energy].max
end

b = max

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
