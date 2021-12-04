require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read

sample_input = """7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"""

class Board
  attr_reader :board, :marked
  def initialize(board)
    @board = board
    @marked = {}
  end

  def call(number)
    @board.each_with_index do |row, y|
      row.each_with_index do |num, x|
        if num == number
          @marked[[x,y]] = true
        end
      end
    end
  end

  def winner
    return true if (0..4).any? { |y| (0..4).all? { |x| @marked[[x, y]] } }
    return true if (0..4).any? { |x| (0..4).all? { |y| @marked[[x, y]] } }
  end

  def unmarked_sum
    (0..4).map { |y| (0..4).map { |x| marked[[x,y]] ? nil : @board[y][x] } }
      .flatten
      .compact
      .sum
  end
end

order = input.split("\n\n").first.split(',').map(&:to_i)
bingo_data = input.split("\n\n")[1..-1].map do |bingo|
  bingo.split("\n").map do |line|
    line.split.map(&:to_i)
  end
end


# Part 1
a = nil
bingos = bingo_data.map { |b| Board.new(b) }
order.each do |number|
  bingos.each do |bingo|
    bingo.call(number)
    if bingo.winner
      break
    end
  end
  if winner = bingos.find { |b| b.winner }
    a = winner.unmarked_sum * number
    break
  end
end

# Part 2
b = nil
winners = []
bingos = bingo_data.map { |b| Board.new(b) }
order.each do |number|
  bingos.each_with_index do |bingo, i|
    next if winners.include?(i)
    bingo.call(number)
    if bingo.winner
      winners << i
    end
  end
  if winners.length == bingos.length
    b = bingos[winners.last].unmarked_sum * number
    break
  end
end



helper.output(a, b)
