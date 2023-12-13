require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1

def index_h_reflect(image, c=1)
  (1...image.length).each do |i|
    dist = [i, image.length - i].min
    mirrored = (0...dist).all? do |j|
      image[i+j] == image[i-1-j]
    end
    return c*i if mirrored
  end
  nil
end

def index_v_reflect(image)
  t_image = image.map(&:chars).transpose.map(&:join)
  index_h_reflect(t_image)
end

images = input.split("\n\n").map { |m| m.split("\n") }
total = 0

a = images.sum do |image|
  index_h_reflect(image, 100) || index_v_reflect(image)
end

# Part 2

def index_h_reflect_smudge(image, c=1)
  (1...image.length).each do |i|
    dist = [i, image.length - i].min
    counts = (0...dist).map do |j|
      m = image[i+j]
      n = image[i-1-j]
      (0...m.length).count { |x| m[x] != n[x] }
    end
    return c*i if counts.count(0) == dist - 1 && counts.count(1) == 1
  end
  nil
end

def index_v_reflect_smudge(image)
  t_image = image.map(&:chars).transpose.map(&:join)
  index_h_reflect_smudge(t_image)
end


total = 0
b = images.sum do |image|
  index_h_reflect_smudge(image, 100) || index_v_reflect_smudge(image)
end



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
