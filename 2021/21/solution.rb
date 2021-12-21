require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
input = input.map { |l| l.split.last.to_i }


# Part 1
player_1 = input.first - 1
player_1_score = 0
player_2 = input.last - 1
player_2_score = 0
rolls = 0
while player_1_score < 1000 && player_2_score < 1000
  move_1 = 0
  3.times do
    move_1 += rolls % 100 + 1
    rolls += 1
  end
  player_1 = (player_1 + move_1) % 10
  player_1_score += player_1 + 1
  break if player_1_score >= 1000
  move_2 = 0
  3.times do
    move_2 += rolls % 100 + 1
    rolls += 1
  end
  player_2 = (player_2 + move_2) % 10
  player_2_score += player_2 + 1
end
a = [player_1_score, player_2_score].min * rolls

# Part 2
DIRAC_DIE = [[3, 1], [4, 3], [5, 6], [6, 7], [7, 6], [8, 3], [9, 1]]
def find_winners(pos_a, pos_b, score_a = 0, score_b = 0, turn = 0)
  return [1, 0] if score_a >= 21
  return [0, 1] if score_b >= 21
  if turn == 0
    total_a, total_b = 0, 0
    DIRAC_DIE.each do |value, co|
      da = (pos_a + value) % 10
      sa = da + 1 + score_a
      win_a, win_b = find_winners(da, pos_b, sa, score_b, 1)
      total_a += (win_a * co)
      total_b += (win_b * co)
    end
    [total_a, total_b]
  else
    total_a, total_b = 0, 0
    DIRAC_DIE.each do |value, co|
      db = (pos_b + value) % 10
      sb = db + 1 + score_b
      win_a, win_b = find_winners(pos_a, db, score_a, sb, 0)
      total_a += (win_a * co)
      total_b += (win_b * co)
    end
    [total_a, total_b]
  end
end
b = find_winners(input.first-1, input.last-1).max



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
