require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

def next_position(a, sign, fraction)
  [
    a.first + fraction.denominator * sign,
    a.last + fraction.numerator * sign
  ]
end

def line_of_sight(positions, a, b)
  x_diff = (b.first - a.first)
  y_diff = (b.last - a.last)
  if x_diff == 0
    sign = y_diff.positive? ? 1 : -1
    position = [a.first, a.last + sign]
    until position == b
      return false if positions.include?(position)
      position = [position.first, position.last + sign]
    end
  else
    fraction = Rational(y_diff, x_diff)
    sign = x_diff.positive? ? 1 : -1
    position = next_position(a, sign, fraction)
    until position == b
      return false if positions.include?(position)
      position = next_position(position, sign, fraction)
    end
  end
  true
end

input = helper.line_separated_strings('input.txt')
rows = input.map { |l| l.split('') }

# Part 1
positions = Hash.new
rows.each_with_index do |row, y|
  row.each_with_index do |col, x|
    if col == "#"
      positions[[x, y]] = true
    end
  end
end
counts = Hash.new
positions.keys.each do |i|
  counts[i] = positions.keys.count do |j|
    if i == j
      false
    else
      line_of_sight(positions, i, j)
    end
  end
end
station = counts.max_by { |k, v| v }
p station.last

# Part 2
station = station.first
two_hundredth = nil
destroyed = 0
until two_hundredth
  visible = Hash.new
  positions.keys.each do |i|
    next if i == station
    if line_of_sight(positions, station, i)
      dx = i.first - station.first
      dy = i.last - station.last
      degrees = ((Math.atan2(dy, dx) / Math::PI * 180) + 90) % 360
      visible[i] = degrees
    end
  end
  visible.sort_by { |k, v| v }.each do |k, v|
    destroyed += 1
    if destroyed == 200
      p k.first * 100 + k.last
      two_hundredth = true
    end
    positions.delete(k)
  end
end
