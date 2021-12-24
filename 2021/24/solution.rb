require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
input = sample_input



class ALUComputer
  attr_reader :program
  attr_accessor :input_array, :memory
  def initialize(raw_program, input_array = [])
    @raw_program = raw_program
    @input_array = input_array
    @memory = {
      w: 0,
      x: 0,
      y: 0,
      z: 0
    }
    parse_program
  end

  def self.run(*args)
    new(*args).run
  end

  def run
    program.each do |line|
      # p line
      # p @memory
      operation = line.first
      values = line[1..-1]
      case operation
      when :inp
        a_addr = arguments(values)[0]
        if input_array.length == 0
          return output
        end
        input = input_array.shift
        @memory[a_addr] = input
      when :add
        a_arg, b_arg = arguments(values)
        @memory[a_arg] = @memory[a_arg] + (@memory[b_arg] || b_arg)
      when :mul
        a_arg, b_arg = arguments(values)
        @memory[a_arg] = @memory[a_arg] * (@memory[b_arg] || b_arg)
      when :div
        a_arg, b_arg = arguments(values)
        @memory[a_arg] = @memory[a_arg] / (@memory[b_arg] || b_arg)
      when :mod
        a_arg, b_arg = arguments(values)
        @memory[a_arg] = @memory[a_arg] % (@memory[b_arg] || b_arg)
      when :eql
        a_arg, b_arg = arguments(values)
        @memory[a_arg] = @memory[a_arg] == (@memory[b_arg] || b_arg) ? 1 : 0
      else
        #nop
      end
    end
    output
  end

  def arguments(values)
    a_addr = ("w".."z").include?(values[0]) ? values[0].to_sym : values[0].to_i
    return [a_addr] unless values.length == 2
    b_addr = ("w".."z").include?(values[1]) ? values[1].to_sym : values[1].to_i
    [a_addr, b_addr]
  end

  def output
    @memory
  end

  def parse_program
    @program = @raw_program.map { |l| [l.first.to_sym] + l[1..-1] }
  end
end



class MonadChecker
  def initialize(input_array)
    @input_array = input_array
    @value = 0
  end

  def self.run(*args)
    new(*args).run
  end

  def run
    # set z to input + 8
    @value += @input_array[0]
    @value += 8

    # z *= 26, z += input + 13
    @value *= 26
    @value += @input_array[1] + 13

    # z *= 26, z += input + 2
    @value *= 26
    @value += @input_array[2] + 2

    # if z % 26 == input
    #   z = z / 26
    # else
    #   z += input + 7
    # end
    if @value % 26 == @input_array[3]
      @value /= 26
    else
      @value += @input_array[3] + 7
    end

    return @value unless @input_array[4]

    # z *= 26, z += input + 11
    @value *= 26
    @value += @input_array[4] + 11

    # z *= 26, z += input + 4
    @value *= 26
    @value += @input_array[5] + 4

    # z *= 26, z += input + 13
    @value *= 26
    @value += @input_array[6] + 13

    # if z % 26 - 8 == input
    #   z = z / 26
    # else
    #   z += input + 13
    # end
    if @value % 26 - 8 == @input_array[7]
      @value /= 26
    else
      @value += @input_array[7] + 13
    end

    return @value unless @input_array[8]

    # if z % 26 - 9 == input
    #   z = z / 26
    # else
    #   z += input + 10
    # end
    if @value % 26 - 9 == @input_array[8]
      @value /= 26
    else
      @value += @input_array[8] + 1
    end

    return @value unless @input_array[9]

    # z *= 26, z += input + 1
    @value *= 26
    @value += @input_array[9] + 1

    # if z % 26 == input
    #   z = z / 26
    # else
    #   z += input + 2
    # end
    if @value % 26 == @input_array[10]
      @value /= 26
    else
      @value += @input_array[10] + 2
    end

    return @value unless @input_array[11]

    # if z % 26 - 5 == input
    #   z = z / 26
    # else
    #   z += input + 14
    # end
    if @value % 26 - 5 == @input_array[11]
      @value /= 26
    else
      @value += @input_array[11] + 14
    end

    return @value unless @input_array[12]

    # if z % 26 - 6 == input
    #   z = z / 26
    # else
    #   z += input + 6
    # end
    if @value % 26 - 6 == @input_array[12]
      @value /= 26
    else
      @value += @input_array[12] + 6
    end

    return @value unless @input_array[13]

    # if z % 26 - 12 == input
    #   z = z / 26
    # else
    #   z += input + 14
    # end
    if @value % 26 - 12 == @input_array[13]
      @value /= 26
    else
      @value += @input_array[13] + 14
    end

    @value
  end
end


# Part 1
# a = nil
# (1..9).to_a.repeated_permutation(14).each do |input_array|
#   p input_array
#   p a
#   if MonadChecker.run(input_array)
#     p a = input_array.map(&:to_s).join
#   end
# end

first_four = []
(1..9).to_a.repeated_permutation(4).each do |input_array|
  output = MonadChecker.run(input_array.dup)
  if output < 10000
    first_four << input_array
  end
end
first_eight = []
first_four.each do |less|
  (1..9).to_a.repeated_permutation(4).each do |more|
    input_array = less + more
    output = MonadChecker.run(input_array.dup)
    if output < 100000000
      first_eight << input_array
    end
  end
end
first_nine = []
first_eight.each do |less|
  (1..9).each do |digit|
    input_array = less + [digit]
    output = MonadChecker.run(input_array.dup)
    if output < 100000
      first_nine << input_array
    end
  end
end
first_eleven = []
first_nine.each do |less|
  (1..9).to_a.repeated_permutation(2).each do |more|
    input_array = less + more
    output = MonadChecker.run(input_array.dup)
    if output < 10000
      first_eleven << input_array
    end
  end
end
first_twelve = []
first_eleven.each do |less|
  (1..9).each do |digit|
    input_array = less + [digit]
    output = MonadChecker.run(input_array.dup)
    if output < 1000
      first_twelve << input_array
    end
  end
end
first_thirteen = []
first_twelve.each do |less|
  (1..9).each do |digit|
    input_array = less + [digit]
    output = MonadChecker.run(input_array.dup)
    if output < 100
      first_thirteen << input_array
    end
  end
end
first_fourteen = []
first_thirteen.each do |less|
  (1..9).each do |digit|
    input_array = less + [digit]
    p output = MonadChecker.run(input_array.dup)
    if output == 0
      first_fourteen << input_array
    end
  end
end
a = first_fourteen.map { |ia| ia.map(&:to_s).join.to_i } .max



# set z to input + 8
block_1 = "inp w
add z 8
add z w
"

# z *= 26, z += input + 13
block_2 = "inp w
mul z 26
add z w
add z 13
"

# z *= 26, z += input + 2
block_3 = "inp w
mul z 26
add z w
add z 2
"

# if z % 26 == input
#   z = z / 26
# else
#   z += input + 7
# end
block_4 = "inp w
add x z
mod x 26
div z 26
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 7
mul y x
add z y
"

# z *= 26, z += input + 11
block_5 = "inp w
mul z 26
add z w
add z 11
"

# z *= 26, z += input + 4
block_6 = "inp w
mul z 26
add z w
add z 4
"

# z *= 26, z += input + 13
block_7 = "inp w
mul z 26
add z w
add z 13
"

# if z % 26 - 8 == input
#   z = z / 26
# else
#   z += input + 13
# end
block_8 = "inp w
mul x 0
add x z
mod x 26
div z 26
add x -8
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y
"

# if z % 26 - 9 == input
#   z = z / 26
# else
#   z += input + 10
# end
block_9 = "inp w
mul x 0
add x z
mod x 26
div z 26
add x -9
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 10
mul y x
add z y
"

# z *= 26, z += input + 1
block_10 = "inp w
mul z 26
add z w
add z 1
"

# if z % 26 == input
#   z = z / 26
# else
#   z += input + 2
# end
block_11 = "inp w
mul x 0
add x z
mod x 26
div z 26
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
"

# if z % 26 - 5 == input
#   z = z / 26
# else
#   z += input + 14
# end
block_12 = "inp w
mul x 0
add x z
mod x 26
div z 26
add x -5
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 14
mul y x
add z y
"

# if z % 26 - 6 == input
#   z = z / 26
# else
#   z += input + 6
# end
block_13 = "inp w
mul x 0
add x z
mod x 26
div z 26
add x -6
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y
"

# if z % 26 - 12 == input
#   z = z / 26
# else
#   z += input + 14
# end
block_14 = "
inp w
mul x 0
add x z
mod x 26
div z 26
add x -12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 14
mul y x
add z y
"

# (1..9).each do |n|
#   (1..9).each do |m|
#     (1..9).each do |o|
#       (1..9).each do |q|
#         (1..9).each do |r|
#           p ALUComputer.run(input, [n,m,o,q,r])
#         end
#       end
#     end
#   end
# end

# set 2

# Part 2
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
