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
    parse.reduce(&compression_proc)
  end

  def repeat(n)
    pws = powers_of_2(n)
    highest = pws.last
    hash = { 1 => compress }
    (2..highest).each do |m|
      lower = hash[m-1]
      hash[m] = compression_proc.call(lower, lower)
    end
    pws.map { |m| hash[m] } .reduce(&compression_proc)
  end

  def self.parse(instructions, options = {})
    new(instructions, options).parse
  end

  def self.compress(instructions, options = {})
    new(instructions, options).compress
  end

  def self.repeat(instructions, repetitions, options = {})
    new(instructions, options).repeat(repetitions)
  end

  private

  def compression_proc
    Proc.new do |a, b|
      a_i, a_o = a
      b_i, b_o = b
      [a_i * b_i % @length, ((a_o * b_i) + b_o) % @length]
    end
  end

  def powers_of_2(n)
    pws = []
    x = 1
    until n == 0
      unless (n % 2 == 0)
        pws << x
      end
      n /= 2
      x += 1
    end
    pws
  end
end
