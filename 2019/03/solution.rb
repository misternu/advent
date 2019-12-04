require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

path1, path2 = helper.plain_csv('input.txt')

def walk(path)
  position = [0,0]
  steps = 0
  wire = {}
  path.each do |section|
    direction = section[0]
    distance = section[1..-1].to_i
    case direction
    when "R"
      distance.times do
        position[0] += 1
        steps += 1
        wire[position.dup] ||= steps
      end
    when "L"
      distance.times do
        position[0] -= 1
        steps += 1
        wire[position.dup] ||= steps
      end
    when "U"
      distance.times do
        position[1] += 1
        steps += 1
        wire[position.dup] ||= steps
      end
    when "D"
      distance.times do
        position[1] -= 1
        steps += 1
        wire[position.dup] ||= steps
      end
    else
      p "ERROR"
      break
    end
  end
  wire
end

wire1 = walk(path1)
wire2 = walk(path2)

# Part 1
intersections = wire1.keys & wire2.keys
p intersections.map { |i| i.map(&:abs).sum } .min

# Part 2
intersection = intersections.min_by { |i| wire1[i] + wire2[i] }
p wire1[intersection] + wire2[intersection]
