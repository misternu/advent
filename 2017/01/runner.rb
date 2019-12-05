require_relative 'solution'

file = File.open('input.txt')
input = file.readline.chomp
puts solution(input)
puts solution2(input)
