require_relative 'unjammer'

input = File.open('input.txt').map(&:strip)

puts Unjammer.unjam(input, {mod: true})