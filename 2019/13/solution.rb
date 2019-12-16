require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

helper = AdventHelper.new(script_root:__dir__)

input = helper.comma_separated_strings('input.txt').map(&:to_i)

class Display
  SPRITES = {
    0 => "  ",
    1 => "⬜️",
    2 => "😐",
    3 => "▄▄",
    4 => "🔴",
    5 => ["😆", "🤓", "😎", "🥺", "🥴", "😍", "😬", "🤪"]
  }
  def initialize
    @pixels = Hash.new(0)
    @width = 42
    @height = 26
  end

  def input(graphics)
    graphics.each_slice(3) do |x, y, v|
      @pixels[[x, y]] = v
      @paddle = x if v == 3
      @ball = x if v == 4
    end
  end

  def print
    puts `clear`
    puts "Score: #{score}"
    (0...@height).each do |y|
      puts (0...@width).map { |x|
        @pixels[[x,y]] == 2 ? SPRITES[5][(y - 2) % 8] : SPRITES[@pixels[[x, y]]]
      }.join
    end
  end

  def ai
    @ball <=> @paddle
  end

  def score
    @pixels[[-1,0]]
  end
end

# Part 1
computer = IntcodeComputer.new(input, IntcodeIO.new([]))
output = computer.run
p output.each_slice(3).map(&:last).count(2)

# Part 2
input[0] = 2
computer = IntcodeComputer.new(input, IntcodeIO.new([]))
display = Display.new
display.input(computer.run)

animate = true

while !computer.stopped
  computer.io.add(display.ai)
  display.input(computer.resume)
  if animate
    display.print
    sleep 0.05
  end
end

p display.score
