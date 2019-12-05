require_relative 'solution'

file = File.open('input.txt')
input = file.readlines.map(&:to_i)
p solution(input.dup)
p solution2(input)
