require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



# Part 1
number_length = 36
mask = nil
memory = Hash.new
input.each do |instr|
  if instr.first == 'mask'
    mask = Hash.new
    instr.last.chars.each_with_index do |char, i|
      next if char == "X"
      mask[i] = char
    end
  else
    full_digits = instr.last.to_i.to_s(2).rjust(number_length, "0")
    value = full_digits.chars.each_with_index.map do |char, i|
      mask[i] ? mask[i] : char
    end .join
    memory[instr[1].to_i] = value
  end
end
a = memory.values.map { |n| n.to_i(2) }.sum

# Part 2
def floating_bits(string)
  return [string] if string.length == 0
  head, *tail = string.chars
  computed_tail = floating_bits(tail.join)
  if ["0", "1"].include?(head)
    computed_tail.map { |t| head + t }
  else
    computed_tail.map { |t| "0" + t } + computed_tail.map { |t| "1" + t }
  end
end

number_length = 36
mask = nil
memory = Hash.new
input.each do |instr|
  if instr.first == 'mask'
    mask = Hash.new
    instr.last.chars.each_with_index do |char, i|
      mask[i] = char
    end
  else
    full_memory_digits = instr[1].to_i.to_s(2).rjust(number_length, "0")
    memory_float = full_memory_digits.chars.each_with_index.map do |char, i|
      case mask[i]
      when "0"
        char
      else
        mask[i]
      end
    end .join
    floating_bits(memory_float).map { |s| s.to_i(2) } .each do |m|
      memory[m] = instr.last.to_i
    end
  end
end

b = memory.values.sum



helper.output(a, b)
