require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
algorithm_input, image_input = input.split("\n\n")
algorithm = {}
algorithm_input.gsub(/\s+/, "").split('').each_with_index do |char, i|
  algorithm[i] = char == "#"
end
image = Hash.new
image_input.split("\n").each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    image[[x,y]] = char == "#" ? "1" : "0"
  end
end
image[:infinite] = "0"


# Part 1
def print_image(data)
  puts
  x_coords = data.keys.select { |k| k != :infinite } .map { |c| c.first }
  y_coords = data.keys.select { |k| k != :infinite } .map { |c| c.last }
  x_min = x_coords.min - 1
  x_max = x_coords.max + 1
  y_min = y_coords.min - 1
  y_max = y_coords.max + 1
  (y_min..y_max).each do |y|
    puts (x_min..x_max).map { |x| data[[x,y]] == "1" ? "#" : '.' }.join
  end
end

def enhance_image(data, algorithm)
  x_coords = data.keys.select { |k| k != :infinite } .map { |c| c.first }
  y_coords = data.keys.select { |k| k != :infinite } .map { |c| c.last }
  x_min = x_coords.min - 1
  x_max = x_coords.max + 1
  y_min = y_coords.min - 1 
  y_max = y_coords.max + 1
  new_data = Hash.new
  (y_min..y_max).each do |y|
    (x_min..x_max).each do |x|
      coords = [
        [x-1, y-1],
        [x  , y-1],
        [x+1, y-1],
        [x-1, y],
        [x  , y],
        [x+1, y],
        [x-1, y+1],
        [x  , y+1],
        [x+1, y+1]
      ]
      digits = coords.map do |c|
        data[c] || data[:infinite]
      end
      number = digits.join.to_i(2)
      value = algorithm[number]
      new_data[[x,y]] = value ? "1" : "0"
    end
  end
  if data[:infinite] == "0"
    new_data[:infinite] = algorithm[0] ? "1" : "0"
  elsif data[:infinite] == "1"
    new_data[:infinite] = algorithm[511] ? "1" : "0"
  end
  new_data
end
2.times do
  image = enhance_image(image, algorithm)
end
a = image.values.count("1")

# Part 2
48.times do
  image = enhance_image(image, algorithm)
end
# print_image(image)
b = image.values.count("1")



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
