require_relative 'solution'

file = File.open('input.txt')
input = file.readlines.map do |line|
  line.split(' ').map(&:to_i)
end
p solution(input)
p solution2(input)
