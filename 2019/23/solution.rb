require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

helper = AdventHelper.new(script_root:__dir__)

program = helper.comma_separated_strings('input.txt').map(&:to_i)

computers = (0..49).map { |i| IntcodeComputer.new(program, IntcodeIO.new([i])) }

packets = Hash.new { |k,v| k[v] = [] }

previous_nat = nil
nat = nil

while true
  computers.each_with_index do |computer, i|
    if packets[i].any?
      computer.io.add(packets[i].shift)
    else
      computer.io.add(-1)
    end

    computer.resume

    if computer.io.outputs.length >= 3
      destination = computer.io.shift
      x = computer.io.shift
      y = computer.io.shift
      unless destination == 255
        packets[destination] << x
        packets[destination] << y
      else
        nat = [x, y]
      end
    end
  end

  if (0..49).all? { |i| packets[i].empty? } && computers.all? { |c| c.io.inputs.empty? }
    if nat && previous_nat && nat[1] == previous_nat[1]
      p nat[1]
      break
    else
      p nat[1] unless previous_nat
      previous_nat = nat
      packets[0] = nat.dup
    end
  end
end
