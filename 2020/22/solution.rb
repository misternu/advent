require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
# input = helper.send(:open_file, 'sample_input.txt').read
decks = input.split("\n\n").map
# input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')


players = Hash.new
decks.each do |deck|
  lines = deck.split("\n")
  player_no = lines.first.split(/\W+/).last.to_i
  cards = lines[1..-1].map(&:to_i)
  players[player_no] = cards
end

# Part 1
while true
  card_1 = players[1].shift
  card_2 = players[2].shift
  if card_1 > card_2
    players[1] += [card_1, card_2]
  else
    players[2] += [card_2, card_1]
  end
  players
  break if players.values.any? { |d| d.empty? }
end
winner = players.values.max_by { |i| i.length }

a = winner.reverse.each_with_index.map { |v, i| v * (i+1) } .sum

# Part 2
decks.each do |deck|
  lines = deck.split("\n")
  player_no = lines.first.split(/\W+/).last.to_i
  cards = lines[1..-1].map(&:to_i)
  players[player_no] = cards
end

def recursive_combat(deck_1, deck_2)
  game_states = Hash.new
  while deck_1.any? && deck_2.any?
    if game_states[[deck_1, deck_2].to_s]
      return [deck_1, deck_2]
    end
    game_states[[deck_1, deck_2].to_s] = true

    card_1 = deck_1.shift
    card_2 = deck_2.shift
    if card_1 <= deck_1.length && card_2 <= deck_2.length
      result = recursive_combat(deck_1.take(card_1), deck_2.take(card_2))
      winner = result.first.any? ? 1 : 2
      if winner == 1
        deck_1 += [card_1, card_2]
      else
        deck_2 += [card_2, card_1]
      end
    else
      if card_1 > card_2
        deck_1 += [card_1, card_2]
      else
        deck_2 += [card_2, card_1]
      end
    end
  end
  [deck_1, deck_2]
end
result = recursive_combat(players[1].dup, players[2].dup)
winner = result.max_by { |i| i.length }

b = winner.reverse.each_with_index.map { |v, i| v * (i+1) } .sum



helper.output(a, b)
