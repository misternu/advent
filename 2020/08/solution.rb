require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
# input = helper.auto_parse
input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')



# Part 1
position = 0
acc = 0
visited = Hash.new

while true
  break if visited[position]
  instr = input[position]
  visited[position] = true
  op, num = instr.split(' ')
  case op
  when 'acc'
    acc += num.to_i
  when 'jmp'
    position += num.to_i
    next
  when 'nop'
  end
  position += 1
end
a = acc

# Part 2
b = nil
(0...input.length).each do |i|
  instrs = input.dup
  op, num = instrs[i].split(' ')
  next if op == 'acc'
  op = op == 'nop' ? 'jmp' : 'nop'
  instrs[i] = [op, num].join(' ')

  position = 0
  acc = 0
  visited = Hash.new

  while true
    break if visited[position] || position >= instrs.length
    instr = instrs[position]
    visited[position] = true
    op, num = instr.split(' ')
    case op
    when 'acc'
      acc += num.to_i
    when 'jmp'
      position += num.to_i
      next
    when 'nop'
    end
    position += 1
  end

  if position == instrs.length
    b = acc
    break
  end
end



helper.output(a, b)
