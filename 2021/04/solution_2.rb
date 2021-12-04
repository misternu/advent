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

order = input.split("\n\n").first.split(',').map(&:to_i)
boards = input.split("\n\n")[1..-1].map do |bingo|
  hash = {}
  bingo.split("\n").each_with_index do |line, y|
    line.split.each_with_index do |num, x|
      hash[[x,y]] = num.to_i
    end
  end
  hash
end

# Both parts
a = nil
b = nil
order.each do |number|
  boards.each { |b| b.delete_if { |k,v| v == number } }
  winners = boards.select do |board|
    board.keys.transpose.map {|v| v.uniq.length }.any? { |l| l < 5 }
  end
  if winners.any?
    winner_value = winners.first.values.sum * number 
    a ||= winner_value
    b = winner_value if boards.length == 1
    boards = boards - winners
  end
end

helper.output(a, b)
