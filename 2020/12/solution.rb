require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



# Part 1
pos = [0,0]
directions = [[1,0], [0,-1], [-1,0], [0,1]]
vector = [1,0]

input.each do |line|
  dir, no = line[0], line[1..-1].to_i
  case dir
  when "N"
    pos[1] += no
  when "S"
    pos[1] -= no
  when "E"
    pos[0] += no
  when "W"
    pos[0] -= no
  when "L"
    current_dir = directions.find_index(vector)
    turns = no / 90
    vector = directions[(current_dir - turns) % 4]
  when "R"
    current_dir = directions.find_index(vector)
    turns = no / 90
    vector = directions[(current_dir + turns) % 4]
  when "F"
    pos = [pos[0] + (no * vector[0]), pos[1] + (no * vector[1])]
  end
end
a = pos.map(&:abs).sum

# Part 2
ship_pos = [0, 0]
waypoint_pos = [10, 1]
vector = 0

input.each do |line|
  dir, no = line[0], line[1..-1].to_i
  case dir
  when "N"
    waypoint_pos[1] += no
  when "S"
    waypoint_pos[1] -= no
  when "E"
    waypoint_pos[0] += no
  when "W"
    waypoint_pos[0] -= no
  when "L"
    turns = no / 90 % 4
    turns.times do
      waypoint_pos = [-waypoint_pos[1], waypoint_pos[0]]
    end
  when "R"
    turns = no / 90 % 4
    turns.times do
      waypoint_pos = [waypoint_pos[1], -waypoint_pos[0]]
    end
  when "F"
    no.times do
      ship_pos = [ship_pos[0] + waypoint_pos[0], ship_pos[1] + waypoint_pos[1]]
    end
  end
end

b = ship_pos.map(&:abs).sum



helper.output(a, b)
