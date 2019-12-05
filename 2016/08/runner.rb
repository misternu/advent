require_relative 'screen'

instructions = File.open('input.txt').map(&:strip)

screen = Screen.new

instructions.each do |instruction|
  if /rect/ =~ instruction
    width, height = /(\d+)x(\d+)/.match(instruction).captures.map(&:to_i)
    screen.rect(width, height)
  elsif /rotate row/ =~ instruction
    row, dist = /=(\d+) by (\d+)/.match(instruction).captures.map(&:to_i)
    screen.rotate_row(row, dist)
  elsif /rotate col/ =~ instruction
    col, dist = /=(\d+) by (\d+)/.match(instruction).captures.map(&:to_i)
    screen.rotate_col(col, dist)
  end
  puts screen
end
# puts screen.pixels.flatten.count { |p| p == "#"}


# TODO: read the letters somehow programmatically.... ?