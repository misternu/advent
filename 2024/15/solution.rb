require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
grid_input, moves_input = input.split("\n\n")
HEIGHT = grid_input.chomp.split("\n").length
WIDTH = grid_input.chomp.split("\n").first.length

# Part 1
grid = {}
pos = nil
grid_input.split("\n").each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    if c == '@'
      pos = [x, y]
      grid[[x, y]] = '.'
    else
      grid[[x, y]] = c
    end
  end
end

moves = []
moves_input.chomp.chars.each do |char|
  case char
  when '^'
    moves << 0
  when '>'
    moves << 1
  when 'v'
    moves << 2
  when '<'
    moves << 3
  end
end

def paint(grid_hash, pos)
  string =(0...HEIGHT).map do |y|
    (0...WIDTH).map do |x|
      if pos == [x, y]
        '@'
      else
        grid_hash[[x, y]]
      end
    end .join
  end .join("\n")
  puts string
end

DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]]
moves.each do |move|
  dx, dy = DIRS[move]

  # check if blocked
  cx, cy = pos[0] + dx, pos[1] + dy
  blocked = false
  loop do
    char = grid[[cx, cy]]
    if char == '#'
      blocked = true
      break
    end
    break if char == '.'

    cx += dx
    cy += dy
  end
  next if blocked

  # move
  pos = [pos[0] + dx, pos[1] + dy]
  pushing = grid[pos] == 'O'
  grid[pos] = '.'

  # push
  next unless pushing

  cx, cy = pos[0].dup, pos[1].dup
  loop do
    cx += dx
    cy += dy
    if grid[[cx, cy]] == '.'
      grid[[cx, cy]] = 'O'
      break
    end
  end
end

a = 0
grid.each do |k, v|
  a += k[0] + (100 * k[1]) if v == 'O'
end

# Part 2
def paint_prime(grid_hash, pos)
  string =(0...HEIGHT).map do |y|
    (0...(WIDTH * 2)).map do |x|
      next '@' if pos == [x, y]
      num = grid_hash[[x, y]]
      num_left = grid_hash[[x - 1, y]]
      if num_left == 1
        ']'
      elsif num.zero?
        '.'
      elsif num == 1
        '['
      elsif num == 2
        '#'
      end      
    end.join
  end.join("\n")
  puts string
end

grid = Hash.new(0)
pos = nil

grid_input.split("\n").each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    case c
    when '@'
      pos = [x * 2, y]
    when 'O'
      grid[[x * 2, y]] += 1
    when '#'
      grid[[x * 2, y]] += 2
      grid[[x * 2 + 1, y]] += 2
    end
  end
end

moves.each do |move|
  # sleep 0.15
  # paint_prime(grid, pos)
  # p move
  dx, dy = DIRS[move]

  # check if blocked
  cx, cy = pos[0] + dx, pos[1] + dy
  blocked = false
  case move
  when 1
    loop do
      num = grid[[cx, cy]]
      break if num.zero?

      if num == 1
        cx += 2
      else
        blocked = true
        break
      end
    end
  when 3
    loop do
      num = grid[[cx - 1, cy]]
      break if grid[[cx, cy]].zero? && num != 1

      if num == 1
        cx -= 2
      else
        blocked = true
        break
      end
    end
  else
    num = grid[[cx, cy]]
    num_left = grid[[cx - 1, cy]]
    if num == 2
      blocked = true
    else
      queue = []
      if num == 1
        queue << [cx, cy]
      elsif num_left == 1
        queue << [cx - 1, cy]
      end

      until queue.empty?
        check = queue.shift
        c_num = grid[[check[0], check[1] + dy]]
        c_num_right = grid[[check[0] + 1, check[1] + dy]]
        if c_num == 2 || c_num_right == 2
          blocked = true
          break
        end
        c_num_left = grid[[check[0] - 1, check[1] + dy]]
        queue << [check[0] - 1, check[1] + dy] if c_num_left == 1
        queue << [check[0], check[1] + dy] if c_num == 1
        queue << [check[0] + 1, check[1] + dy] if c_num_right == 1
      end
    end
  end
  next if blocked

  # move
  cx, cy = pos[0] + dx, pos[1] + dy
  pos = [cx.dup, cy.dup]
  queue = []
  case move
  when 1
    queue << pos if grid[pos] == 1
    grid[pos] = 0
  when 3
    block_pos = [cx - 1, cy]
    if grid[block_pos] == 1
      queue << block_pos
      grid[block_pos] = 0
    end
  else
    block_pos_left = [cx - 1, cy]
    if grid[block_pos_left] == 1
      queue << block_pos_left
      grid[block_pos_left] = 0
    end
    if grid[pos] == 1
      queue << pos
      grid[pos] = 0
    end
  end
  next if queue.empty?

  # pushing
  case move
  when 1
    bx, by = queue.first
    loop do
      n = [bx + 2, by]
      num = grid[n]
      grid[[bx + 1, by]] = 1
      break if num != 1

      grid[n] = 0
      bx += 2
    end
  when 3
    bx, by = queue.first
    loop do
      n = [bx - 2, by]
      num = grid[n]
      grid[[bx - 1, by]] = 1
      break if num != 1

      grid[n] = 0
      bx -= 2
    end
  else
    until queue.empty?
      bx, by = queue.shift
      mid = [bx, by + dy]
      left = [bx - 1, by + dy]
      right = [bx + 1, by + dy]
      if grid[mid] == 1
        queue << mid
        next
      end
      if grid[left] == 1
        queue << left
        grid[left] = 0
      end
      if grid[right] == 1
        queue << right
        grid[right] = 0
      end
      grid[mid] = 1
    end
  end
end
# paint_prime(grid, pos)

b = 0
grid.each do |k, v|
  b += k[0] + (100 * k[1]) if v == 1
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
