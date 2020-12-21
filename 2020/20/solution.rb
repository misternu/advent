require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
# input = helper.send(:open_file, 'sample_input.txt').read
input_tiles = input.split("\n\n").map { |r| r.split("\n") }
# input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



# Part 1
tiles = Hash.new
input_tiles.each do |tile|
  id, *data = tile
  id = id.split(/\W+/).last.to_i

  top = data.first.split('').map { |c| c == "#" ? "1" : 0 }.join
  bottom = data.last.split('').map { |c| c == "#" ? "1" : 0 }.join.reverse
  transposed = data.map { |l| l.split('') }.transpose
  left = transposed.first.map { |c| c == "#" ? "1" : 0 }.join.reverse
  right = transposed.last.map { |c| c == "#" ? "1" : 0 }.join

  tiles[id] = [top, right, bottom, left]
end

image_data = Hash.new
input_tiles.each do |tile|
  id, *data = tile
  id = id.split(/\W+/).last.to_i
  data = data[1..-2].map { |line| line[1..-2] }
  image_data[id] = data
end

side_length = Math.sqrt(tiles.length).to_i
edge_pieces = (side_length - 2) * 4

corner_piece_ids = []
side_piece_ids = []

tiles.each do |i, data|
  other_tiles = tiles.select { |j, d| j != i }
  count = data.count { |d|
    other_tiles.any? { |j, e|
      e.any? { |f|
        f == d || f == d.reverse
      }
    }
  }
  if count == 2
    corner_piece_ids << i
  elsif count == 3
    side_piece_ids << i
  end
end

a = corner_piece_ids.reduce(&:*)

# Part 2
# Construct image
positions = Hash.new
top_left_corner = corner_piece_ids.first
other_tiles = other_tiles = tiles.select { |j, d| j != top_left_corner }
top_left_used = tiles[top_left_corner].map { |d|
  other_tiles.any? { |j, e|
    e.any? { |f| f == d || f == d.reverse}
  }
}
top_left_rotation = (0..3).find { |r|
  top_left_used.rotate(-r) == [false, true, true, false]
}
positions[top_left_corner] = [0, 0, top_left_rotation, false]

top_row = [top_left_corner]
current_x = 1
other_edge_pieces = tiles.select { |j, d| side_piece_ids.include?(j) }
while current_x < side_length - 1
  # p current_x
  rightmost_tile = tiles[top_row.last]
  if positions[top_row.last].last
    rightmost_tile = rightmost_tile.reverse.map { |d| d.reverse }
  end
  right_edge = rightmost_tile.rotate(-positions[top_row.last][2])[1]

  next_edge_piece = other_edge_pieces.find { |i, d|
    d.any? { |e| e == right_edge || e == right_edge.reverse }
  }
  other_edge_pieces.delete(next_edge_piece[0])

  flipped = next_edge_piece[1].any? { |d| d == right_edge }
  if flipped
    next_edge_piece[1] = next_edge_piece[1].reverse.map { |d| d.reverse }
  end

  all_other_tiles = tiles.select { |j, e| j != next_edge_piece[0] }
  edge_piece_used = next_edge_piece[1].map { |d|
    all_other_tiles.any? { |j, e|
      e.any? { |f| f == d || f == d.reverse }
    }
  }
  edge_piece_rotation = (0..3).find { |r|
    edge_piece_used.rotate(-r) == [false, true, true, true]
  }

  top_row << next_edge_piece[0]
  positions[next_edge_piece[0]] = [current_x, 0, edge_piece_rotation, flipped]
  current_x += 1
end

# top right corner
rightmost_tile = tiles[top_row.last]
if positions[top_row.last].last
  rightmost_tile = rightmost_tile.reverse.map { |d| d.reverse }
end
right_edge = rightmost_tile.rotate(-positions[top_row.last][2])[1]
other_corner_pieces = tiles.select { |j, d| corner_piece_ids[1..-1].include?(j) }
next_edge_piece = other_corner_pieces.find { |i, d|
  d.any? { |e| e == right_edge || e == right_edge.reverse }
}
flipped = next_edge_piece[1].any? { |d| d == right_edge }
if flipped
  next_edge_piece[1] = next_edge_piece[1].reverse.map { |d| d.reverse }
end
all_other_tiles = tiles.select { |j, e| j != next_edge_piece[0] }
edge_piece_used = next_edge_piece[1].map { |d|
  all_other_tiles.any? { |j, e|
    e.any? { |f| f == d || f == d.reverse }
  }
}
edge_piece_rotation = (0..3).find { |r|
  edge_piece_used.rotate(-r) == [false, false, true, true]
}
top_row << next_edge_piece[0]
positions[next_edge_piece[0]] = [current_x, 0, edge_piece_rotation, flipped]



# other rows
unplaced_piece_ids = tiles.keys.reject { |i| positions.keys.include?(i) }
unplaced_tiles = tiles.select { |i, d| unplaced_piece_ids.include?(i) }
(1...side_length).each do |y|
  (0...side_length).each do |x|
    tile_above_position = positions.values.find { |pos|
      pos[0] == x && pos[1] == y - 1
    }
    tile_id = positions.key(tile_above_position)
    tile_above = tiles[tile_id]
    if tile_above_position.last
      tile_above = tile_above.reverse.map { |d| d.reverse }
    end
    bottom_edge = tile_above.rotate(-tile_above_position[2])[2]

    next_piece = unplaced_tiles.find { |i, d|
      d.any? { |e| e == bottom_edge || e == bottom_edge.reverse }
    }
    unplaced_tiles.delete(next_piece[0])

    flipped = next_piece[1].any? { |d| d == bottom_edge }
    if flipped
      next_piece[1] = next_piece[1].reverse.map { |d| d.reverse }
    end

    next_piece_rotation = (0..3).find { |r|
      next_piece[1].rotate(-r)[0].reverse == bottom_edge
    }

    positions[next_piece[0]] = [x, y, next_piece_rotation, flipped]
  end
end

# draw it
grid = []
(side_length * 8).times do
  grid << ""
end

def rotate_image(image)
  new_image = []
  image.map { |l| l.chars }.transpose.each do |row|
    new_image << row.reverse.join
  end
  new_image
end

def flip_image(image)
  image.map { |l| l.chars }.transpose.map(&:join)
end

(0...side_length).each do |y|
  (0...side_length).each do |x|
    tile_position = positions.values.find { |pos|
      pos[0] == x && pos[1] == y
    }
    tile_id = positions.key(tile_position)

    tile_image = image_data[tile_id]

    if tile_position[3]
      tile_image = flip_image(tile_image)
    end

    tile_position[2].times do
      tile_image = rotate_image(tile_image)
    end

    row_start = (y * 8)
    tile_image.each_with_index do |line, i|
      grid[row_start + i] += line
    end
  end
end

# puts grid

sea_monster = [
  "                  # ",
  "#    ##    ##    ###",
  " #  #  #  #  #  #   "
]

target = sea_monster.map do |line|
  chars = line.chars
  chars.each_index.select { |i| chars[i] == "#" }
end

monster_width = 20
monster_height = 3

def scan_image(image, target, target_width, target_height)
  width = image.first.length
  height = image.length
  indices = []
  (0..height-target_height).each do |y|
    (0..width-target_width).each do |x|
      found = target.each_with_index.all? do |row, dy|
        row.all? do |dx|
          image[y + dy][x + dx] == "#"
        end
      end
      if found
        indices << [x, y]
      end
    end
  end
  indices
end

grid = rotate_image(grid)

monster_locations = scan_image(grid, target, monster_width, monster_height)

masked_grid = grid.dup

monster_locations.each do |x, y|
  target.each_with_index do |row, dy|
    row.each_with_index do |dx|
      masked_grid[y + dy][x + dx] = "."
    end
  end
end

b = masked_grid.map { |line| line.chars.count("#") } .sum



helper.output(a, b)
