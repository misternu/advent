require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)



# Part 1
# input = sample_input
row_len = input.first.length
num_rows = input.length
number_pos = {}
part_pos = {}
input.each_with_index do |row, y|
  reading = false
  row.chars.each_with_index do |col, x|
    if /\d/ =~ col
      if reading
        number_pos[reading] += 1
      else
        reading = [x, y]
        number_pos[reading] = 1
      end
    elsif /\./ =~ col
      reading = false
    else
      reading = false
      part_pos[[x,y]] = true
    end
  end
end
sum = 0
number_pos.each do |pos, length|
  x, y = pos
  x_start = [0, x-1].max
  x_end = [row_len-1, x+length].min

  has_part = false

  if y > 0
    (x_start..x_end).each do |dx|
      if part_pos[[dx, y-1]]
        has_part = true
      end
    end
  end

  if x > 0
    if part_pos[[x-1, y]]
      has_part = true
    end
  end

  if (x+length) < (row_len-1)
    if part_pos[[x+length, y]]
      has_part = true
    end
  end

  if y < num_rows - 1
    (x_start..x_end).each do |dx|
      if part_pos[[dx, y+1]]
        has_part = true
      end
    end
  end

  if has_part
    sum += input[y][x...(x+length)].to_i
  end
end

a = sum

# Part 2
star_pos = {}
star_count = {}
part_pos.keys.each do |key|
  x, y = key
  if input[y][x] == "*"
    star_pos[[x,y]] = 1
    star_count[[x,y]] = 0
  end
end
number_pos.each do |pos, length|
  x, y = pos
  x_start = [0, x-1].max
  x_end = [row_len-1, x+length].min

  value = input[y][x...(x+length)].to_i

  if y > 0
    (x_start..x_end).each do |dx|
      if star_pos[[dx, y-1]]
        star_pos[[dx, y-1]] *= value
        star_count[[dx, y-1]] += 1
      end
    end
  end

  if x > 0
    if star_pos[[x-1, y]]
      star_pos[[x-1, y]] *= value
      star_count[[x-1, y]] += 1
    end
  end

  if (x+length) < (row_len-1)
    if star_pos[[x+length, y]]
      star_pos[[x+length, y]] *= value
      star_count[[x+length, y]] += 1
    end
  end

  if y < num_rows - 1
    (x_start..x_end).each do |dx|
      if star_pos[[dx, y+1]]
        star_pos[[dx, y+1]] *= value
        star_count[[dx, y+1]] += 1
      end
    end
  end
end

sum = 0
star_count.each do |pos, num|
  if num == 2
    sum += star_pos[pos]
  end
end

b = sum



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
