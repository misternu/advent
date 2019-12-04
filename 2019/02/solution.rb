require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.comma_separated_strings('input.txt').map(&:to_i)

# Part One
memory = input.dup
memory[1] = 12
memory[2] = 2
position = 0
while true
  opcode = memory[position]
  a = memory[position + 1]
  b = memory[position + 2]
  c = memory[position + 3]
  case opcode
  when 1
    memory[c] = memory[a] + memory[b]
    position += 4
  when 2
    memory[c] = memory[a] * memory[b]
    position += 4
  when 99
    break
  end
end
p memory[0]

# Part Two
(0..99).each do |noun|
  (0..99).each do |verb|
    memory = input.dup
    memory[1] = noun
    memory[2] = verb
    # p [noun, verb]
    position = 0
    while true
      opcode = memory[position]
      a = memory[position + 1]
      b = memory[position + 2]
      c = memory[position + 3]
      case opcode
      when 1
        memory[c] = memory[a] + memory[b]
        position += 4
      when 2
        memory[c] = memory[a] * memory[b]
        position += 4
      when 99
        break
      else
        p opcode
      end
    end
    if memory[0] == 19690720
      p 100 * noun + verb
      break
    end
  end
end
