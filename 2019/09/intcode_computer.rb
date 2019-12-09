class IntcodeIO
  attr_reader :inputs, :outputs
  def initialize(inputs)
    @inputs = inputs
    @outputs = []
  end

  def input
    @inputs.shift
  end

  def output(value)
    @outputs << value
  end

  def add(input)
    @inputs << input
  end

  def shift
    @outputs.shift
  end

  def print
    @outputs
  end
end

class IntcodeComputer
  attr_reader :io, :offset_register
  attr_accessor :waiting, :stopped
  def initialize(memory, io = IntcodeIO.new([]), options = {})
    @memory = Hash.new(0)
    memory.each_with_index do |int, i|
      @memory[i] = int
    end
    @io = io
    @address = options.fetch(:address, 0)
    @wait_on_output = options.fetch(:wait, false)
    @should_step = true
    @waiting = false
    @stopped = false
    @offset_register = 0
  end

  def run
    while !@waiting && operate[1]
      step
      @opcode = nil
      @should_step = true
    end
    halt
  end

  def operate

    case opcode
    when 1
      [add, true]
    when 2
      [multiply, true]
    when 3
      [input, true]
    when 4
      [output, true]
    when 5
      [jump_if_true, true]
    when 6
      [jump_if_false, true]
    when 7
      [less_than, true]
    when 8
      [equals, true]
    when 9
      [offset, true]
    when 99
      [stop, false]
    else
      [error, false]
    end
  end

  def add
    a, b, c = parameters
    a_mode, b_mode, c_mode = modes
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    b_value = [@memory[b], b, @memory[offset_register + b]][b_mode]
    c_value = [c, c, offset_register + c][c_mode]
    @memory[c_value] = a_value + b_value
  end

  def multiply
    a, b, c = parameters
    a_mode, b_mode, c_mode = modes
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    b_value = [@memory[b], b, @memory[offset_register + b]][b_mode]
    c_value = [c, c, offset_register + c][c_mode]
    @memory[c_value] = a_value * b_value
  end

  def input
    a = parameters.first
    a_mode = modes.first
    a_value = [a, a, offset_register + a][a_mode]
    value = @io.input
    unless value
      @waiting = true
      @should_step = false
    end
    @memory[a_value] = value
  end

  def output
    a = parameters.first
    a_mode = modes.first
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    @io.output(a_value)
    if @wait_on_output
      @waiting = true
    end
  end

  def jump_if_true
    a, b = parameters
    a_mode, b_mode = modes
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    b_value = [@memory[b], b, @memory[offset_register + b]][b_mode]
    if a_value != 0
      @address = b_value
      @should_step = false
    end
  end

  def jump_if_false
    a, b = parameters
    a_mode, b_mode = modes
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    b_value = [@memory[b], b, @memory[offset_register + b]][b_mode]
    if a_value == 0
      @address = b_value
      @should_step = false
    end
  end

  def less_than
    a, b, c = parameters
    a_mode, b_mode, c_mode = modes
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    b_value = [@memory[b], b, @memory[offset_register + b]][b_mode]
    c_value = [c, c, offset_register + c][c_mode]
    if a_value < b_value
      @memory[c_value] = 1
    else
      @memory[c_value] = 0
    end
  end

  def equals
    a, b, c = parameters
    a_mode, b_mode, c_mode = modes
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    b_value = [@memory[b], b, @memory[offset_register + b]][b_mode]
    c_value = [c, c, offset_register + c][c_mode]
    if a_value == b_value
      @memory[c_value] = 1
    else
      @memory[c_value] = 0
    end
  end

  def offset
    a = parameters.first
    a_mode = modes.first
    a_value = [@memory[a], a, @memory[offset_register + a]][a_mode]
    @offset_register += a_value
  end

  def opcode
    return @opcode if @opcode
    return 99 unless @memory[@address]
    integer = @memory[@address]
    ones = integer % 10
    tens = (integer / 10) % 10
    @opcode = tens * 10 + ones
  end

  def parameters
    if [1, 2, 7, 8].include?(opcode)
      get(3)
    elsif [5, 6].include?(opcode)
      get(2)
    elsif [3, 4, 9].include?(opcode)
      get(1)
    else
      get(0)
    end
  end

  def modes
    integer = @memory[@address]
    first = (integer / 100) % 10
    second = (integer / 1000) % 10
    third = (integer / 10000) % 10
    mode_list = [first, second, third]
    if [3, 4, 9].include?(opcode)
      mode_list.slice(0,1)
    elsif [5, 6].include?(opcode)
      mode_list.slice(0,2)
    else
      mode_list
    end
  end

  def get(number)
    three = [
      @memory[@address + 1],
      @memory[@address + 2],
      @memory[@address + 3]
    ]
    three.slice(0, number)
  end

  def step
    return unless @should_step
    if [1, 2, 7, 8].include?(opcode)
      @address += 4
    elsif [5, 6].include?(opcode)
      @address += 3
    elsif [3, 4, 9].include?(opcode)
      @address += 2
    end
  end

  def stop
    @stopped = true
  end

  def halt
    @io.print
  end

  def error

  end
end
