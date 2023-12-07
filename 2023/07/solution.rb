require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)


# input = sample_input

CARDS = %w[A K Q J T 9 8 7 6 5 4 3 2]
CARDS_2 = %w[A K Q T 9 8 7 6 5 4 3 2 J]
RANKS = [:five, :four, :full, :three, :two_pair, :pair, :high]

def get_label(hand, wilds = false)
  counts = Hash.new(0)
  hand.chars.each do |ch|
    counts[ch] += 1
  end

  if wilds && counts["J"] > 0
    j_count = counts["J"]
    counts.delete("J")
    return :five if counts.values.length == 0
    return :five if counts.values.length == 1
    return :four if j_count == 3 && counts.values.any? { |v| v == 1 } 
    return :four if j_count == 2 && counts.values.any? { |v| v == 2 }
    return :four if j_count == 1 && counts.values.any? { |v| v == 3 }
    return :full if j_count == 1 && counts.values.count(2) == 2
    return :three if j_count == 1 && counts.values.any? { |v| v == 2 }
    return :three if j_count == 2
    return :pair if j_count == 1
  end

  return :five if counts.values.any? { |v| v == 5 }
  return :four if counts.values.any? { |v| v == 4 }
  if counts.values.any? { |v| v == 3 }
    return :three unless counts.values.any? { |v| v == 2 }
    return :full
  end
  return :two_pair if counts.values.count { |v| v == 2 } == 2 
  return :pair if counts.values.any? { |v| v == 2 } 
  return :high
end

def get_nums(hand, wilds = false)
  if wilds
    hand.chars.map { |ch| CARDS_2.index(ch) }
  else
    hand.chars.map { |ch| CARDS.index(ch) }
  end
end

def sort_hands(hand_bets, wilds = false)
  hand_bets.sort_by do |hand_bet|
    hand, bet = hand_bet
    label = get_label(hand, wilds)
    rank_index = RANKS.index(label)
    nums = get_nums(hand, wilds)
    [rank_index] + nums
  end
end

def pay_hands(hands)
  hands.each_with_index.map do |hand_bet, i|
    hand, bet = hand_bet
    bet.to_i * (hands.length - i)
  end
end

# Part 1
sorted_hands = sort_hands(input)
hand_pays = pay_hands(sorted_hands)
a = hand_pays.sum

# Part 2
sorted_hands = sort_hands(input, true)
hand_pays = pay_hands(sorted_hands)

b = hand_pays.sum



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
