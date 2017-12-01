require 'csv'
require_relative 'person'

moves = CSV.read('input.csv').flatten.map(&:strip)
moves.map! do |move|
  m = /(\D)(.*)/.match(move)
  [m[1], m[2].to_i]
end

me = Person.new
moves.each do |move|
  me.turn(move[0])
  me.move(move[1])
end

me.path.each_index do |index|
  loc = me.path[index]
  if me.path[0...index].include?(loc)
    puts loc[0].abs + loc[1].abs
    break
  end
end