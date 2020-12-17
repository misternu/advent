require_relative '../../lib/advent_helper'
require 'set'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse('input.txt', map: true)
# input = helper.auto_parse('sample_input.txt', map: true)
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')


# Part 1
def neighbors(pos)
  (-1..1).map do |dx|
    (-1..1).map do |dy|
      (-1..1).map do |dz|
        next if dx == 0 && dy == 0 && dz == 0
        [pos[0] + dx, pos[1] + dy, pos[2] + dz]
      end
    end
  end .flatten(2).compact
end


active = Hash.new
input.each_with_index do |row, y|
  row.each_with_index do |col, x|
    active[[x,y,0]] = col == "#"
  end
end

6.times do
  potential = Set.new(active.select { |k,v| v }.keys)
  edge = Set.new
  potential.each do |p|
    edge.merge(neighbors(p))
  end
  potential.merge(edge)

  new_active = Hash.new
  potential.each do |p|
    if active[p]
      count = neighbors(p).count { |n| active[n] }
      if count == 2 || count == 3
        new_active[p] = true
      end
    else
      count = neighbors(p).count { |n| active[n] }
      if count == 3
        new_active[p] = true
      end
    end
  end
  active = new_active
end
a = active.keys.count

# Part 2
def neighbors_four_dee(pos)
  (-1..1).map do |dx|
    (-1..1).map do |dy|
      (-1..1).map do |dz|
        (-1..1).map do |dw|
          next if dx == 0 && dy == 0 && dz == 0 && dw == 0
          [pos[0] + dx, pos[1] + dy, pos[2] + dz, pos[3] + dw]
        end
      end
    end
  end .flatten(3).compact
end


active = Hash.new
input.each_with_index do |row, y|
  row.each_with_index do |col, x|
    active[[x,y,0,0]] = col == "#"
  end
end

6.times do
  potential = Set.new(active.select { |k,v| v }.keys)
  edge = Set.new
  potential.each do |p|
    edge.merge(neighbors_four_dee(p))
  end
  potential.merge(edge)

  new_active = Hash.new
  potential.each do |p|
    if active[p]
      count = neighbors_four_dee(p).count { |n| active[n] }
      if count == 2 || count == 3
        new_active[p] = true
      end
    else
      count = neighbors_four_dee(p).count { |n| active[n] }
      if count == 3
        new_active[p] = true
      end
    end
  end
  active = new_active
end

b = active.keys.count



helper.output(a, b)
