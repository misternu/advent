require_relative 'triangle_validate'

file = File.open('input.txt')

triangles = []

file.each_slice(3) do |slice|
  three = slice.map do |row|
    row.gsub(/\s+/, ' ').strip.split(' ').map(&:to_i)
  end
  triangles += three.transpose
end

p triangles.count { |triangle| validate(triangle) }