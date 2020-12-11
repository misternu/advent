require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
# input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')
# input = helper.comma_separated_strings('input.txt')



# Part 1
height = input.length
width = input.first.length
seats = Hash.new
input.each_with_index do |row, y|
  row.chars.each_with_index do |col, x|
    if col == "L"
      seats[[x,y]] = true
    end
  end
end

def neighbors(pos, options = {})
  x, y = pos
  [
    [x,y-1],
    [x+1,y-1],
    [x+1,y],
    [x+1,y+1],
    [x,y+1],
    [x-1,y+1],
    [x-1,y],
    [x-1,y-1]
  ].select { |i,j| options[:seats][[i,j]] && i >= 0 && i < options[:width] && j >= 0 && j < options[:height] }
end

def occupied(pos, taken, options = {})
  neighboring_seats = neighbors(pos, options)
  return true if !taken[pos] && neighboring_seats.none? { |seat| taken[seat] }
  return false if taken[pos] && neighboring_seats.count { |seat| taken[seat] } >= 4
  taken[pos]
end

givens = { height: height, width: width, seats: seats }

taken = Hash.new

while true
  new_taken = Hash.new
  seats.keys.each do |pos|
    new_taken[pos] = occupied(pos, taken, givens)
  end

  if new_taken.all? { |k,v| taken[k] == v }
    break
  end
  taken = new_taken
end

a = taken.values.count(true)


# Part 2
true_neighbors = Hash.new { |h, k| h[k] = [] }
seats.keys.each do |seat|
  output = []
  x, y = seat
  pos = [x,y-1]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[1] -= 1
  end
  output << pos if seats[pos]
  pos = [x+1,y-1]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[0] += 1
    pos[1] -= 1
  end
  output << pos if seats[pos]
  pos = [x+1,y]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[0] += 1
  end
  output << pos if seats[pos]
  pos = [x+1,y+1]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[0] += 1
    pos[1] += 1
  end
  output << pos if seats[pos]
  pos = [x,y+1]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[1] += 1
  end
  output << pos if seats[pos]
  pos = [x-1,y+1]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[0] -= 1
    pos[1] += 1
  end
  output << pos if seats[pos]
  pos = [x-1,y]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[0] -= 1
  end
  output << pos if seats[pos]
  pos = [x-1,y-1]
  until seats[pos] || pos[0] < 0 || pos[0] >= width || pos[1] < 0 || pos[1] >= height
    pos[0] -= 1
    pos[1] -= 1
  end
  output << pos if seats[pos]
  true_neighbors[seat] = output
end

def new_occupied(pos, seats, taken, neighbors)
  neighboring_seats = neighbors[pos]
  return true if !taken[pos] && neighboring_seats.none? { |seat| taken[seat] }
  return false if taken[pos] && neighboring_seats.count { |seat| taken[seat] } >= 5
  taken[pos]
end

taken = Hash.new

while true
  new_taken = Hash.new
  seats.keys.each do |pos|
    new_taken[pos] = new_occupied(pos, seats, taken, true_neighbors)
  end

  break if new_taken == taken
  taken = new_taken
end

b = taken.values.count(true)



helper.output(a, b)
