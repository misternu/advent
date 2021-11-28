class InstructionParser
  def initialize(instructions, options = {})
    @instructions = instructions
    @length = options.fetch(:length, 10)
  end

  def translate(line)
    case line
    when /deal into new/
      [-1, -1]
    when /deal with increment/
      [line.split(' ').last.to_i, 0]
    else
      [1, -line.split(' ').last.to_i]
    end
  end

  def parse
    @instructions.map do |line|
      translate(line)
    end
  end

  def compress
    parse.reduce do |a, b|
      a_i, a_o = a
      b_i, b_o = b
      [a_i * b_i % @length, ((a_o * b_i) + b_o) % @length]
    end
  end

  def self.parse(instructions, options = {})
    new(instructions, options).parse
  end

  def self.compress(instructions, options = {})
    new(instructions, options).compress
  end
end
