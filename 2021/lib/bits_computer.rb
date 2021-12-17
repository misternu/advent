require_relative 'packet_parser'

class BitsComputer
  attr_reader :bits
  def initialize(hex = '')
    @hex = hex
  end

  def self.run(*args)
    new(*args).run
  end

  def run
    parse_hex_to_bits
    parse_bits_to_packets
  end

  def parse_hex_to_bits
    @bits = @hex.to_i(16).to_s(2)
  end

  def parse_bits_to_packets
    @packets = PacketParser.parse(bits)
  end
end
