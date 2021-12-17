require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = [(185..221), (-122..-74)]
sample_input = [(20..30), (-10..-5)]
# MemoryProfiler.start(allow_files: __FILE__)
input = sample_input



# Part 1
def test_trajectory(dx, dy, target_x, target_y)
  pos = [0,0]
  max_y = pos.last
  until pos.last < target_y.first || pos.first > target_x.last
    pos[0] += dx
    pos[1] += dy
    max_y = [pos.last, max_y].max
    return max_y if target_x.include?(pos[0]) && target_y.include?(pos[1])
    dx -= 1 if dx > 0
    dx += 1 if dx < 0
    dy -= 1
  end
  false
end
target_x = input.first.to_a
target_y = input.last.to_a
best_trajectory = nil
best_height = 0
(0..target_x.first).each do |dx|
  (0..300).each do |dy|
    max_y = test_trajectory(dx, dy, target_x, target_y)
    if max_y && max_y > best_height
      best_height = max_y
      best_trajectory = [dx, dy]
    end
  end
end
a = best_height

# Part 2
b = (0..target_x.last).sum do |dx|
  (target_y.first..best_trajectory.last).count do |dy|
    test_trajectory(dx, dy, target_x, target_y) != false
  end
end




# MemoryProfiler.stop.pretty_print
helper.output(a, b)
