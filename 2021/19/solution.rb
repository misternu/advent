require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
input = input.split("\n\n").map { |l| l.split("\n") }



scanners = []
input.each do |scanner|
  scanners << scanner[1..-1].map { |l| l.split(',').map(&:to_i) }
end

ORIENTATIONS = [
  # (1, 3, -2)
  Proc.new { |x, y, z| [x, z, -y] },
  # (-3, 1, -2)
  Proc.new { |x, y, z| [-z, x, -y] },
  # (-1, -3, -2)
  Proc.new { |x, y, z| [-x, -z, -y] },
  # (3, -1, -2)
  Proc.new { |x, y, z| [z, -x, -y] },
  # (3, -2, 1)
  Proc.new { |x, y, z| [z, -y, x] },
  # (2, 3, 1)
  Proc.new { |x, y, z| [y, z, x] },
  # (-3, 2, 1)
  Proc.new { |x, y, z| [-z, y, x] },
  # (-2, -3, 1)
  Proc.new { |x, y, z| [-y, -z, x] },
  # (-2, 1, 3)
  Proc.new { |x, y, z| [-y, x, z] },
  # (-1, -2, 3)
  Proc.new { |x, y, z| [-x, -y, z] },
  # (2, -1, 3)
  Proc.new { |x, y, z| [y, -x, z] },
  # (1, 2, 3)
  Proc.new { |x, y, z| [x, y, z] },
  # (-3, -1, 2)
  Proc.new { |x, y, z| [-z, -x, y] },
  # (1, -3, 2)
  Proc.new { |x, y, z| [x, -z, y] },
  # (3, 1, 2)
  Proc.new { |x, y, z| [z, x, y] },
  # (-1, 3, 2)
  Proc.new { |x, y, z| [-x, z, y] },
  # (-1, 2, -3)
  Proc.new { |x, y, z| [-x, y, -z] },
  # (-2, -1, -3)
  Proc.new { |x, y, z| [-y, -x, -z] },
  # (1, -2, -3)
  Proc.new { |x, y, z| [x, -y, -z] },
  # (2, 1, -3)
  Proc.new { |x, y, z| [y, x, -z] },
  # (2, -3, -1)
  Proc.new { |x, y, z| [y, -z, -x] },
  # (3, 2, -1)
  Proc.new { |x, y, z| [z, y, -x] },
  # (-2, 3, -1)
  Proc.new { |x, y, z| [-y, z, -x] },
  # (-3, -2, -1)
  Proc.new { |x, y, z| [-z, -y, -x] }
].freeze
# Part 1

def count_matches(a, ori_a, b, ori_b, offset)
  turned_a = a.map { |pos| ori_a.call(pos) }
  b.count do |pos_b|
    turned_b = ori_b.call(pos_b)
    offset_b = turned_b.zip(offset).map { |x, y| x + y }
    turned_a.include?(offset_b)
  end
end

def find_overlap(a, b, ori_a)
  ORIENTATIONS.each do |ori_b|
    a.each do |pos_a|
      turned_a = ori_a.call(pos_a)
      b.each do |pos_b|
        turned_b = ori_b.call(pos_b)
        offset = turned_a.zip(turned_b).map { |x, y| x - y }
        count = count_matches(a, ori_a, b, ori_b, offset)
        if count >= 12
          return [offset, ori_b]
        end
      end
    end
  end
  false
end

def get_beacons(scanner, orientation, offset)
  scanner.map do |pos|
    orientation.call(pos).zip(offset).map { |x, y| x + y }
  end
end

known_scanners = {
  0 => {
    position: [0, 0, 0],
    orientation: ORIENTATIONS[11]
  }
}

queue = [0]

until queue.empty?
  scanner_index = queue.shift
  current = scanners[scanner_index]
  current_data = known_scanners[scanner_index]
  scanners.each_with_index do |scanner, i|
    next if known_scanners.has_key?(i)
    found = find_overlap(current, scanner, current_data[:orientation])
    next unless found
    offset, orientation = found
    queue << i
    new_location = current_data[:position].zip(offset).map { |x, y| x + y }
    known_scanners[i] = {
      position: new_location,
      orientation: orientation
    }
  end
end

beacons = {}
scanners.each_with_index do |scanner, i|
  data = known_scanners[i]
  get_beacons(scanner, data[:orientation], data[:position]).each do |beacon|
    beacons[beacon] = true
  end
end

a = beacons.keys.count

# Part 2
b = 0
(0...scanners.length).to_a.combination(2).each do |i, j|
  a_pos = known_scanners[i][:position]
  b_pos = known_scanners[j][:position]
  manhattan = a_pos.zip(b_pos).sum { |x, y| (x - y).abs }
  b = [b, manhattan].max
end



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
