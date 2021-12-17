require_relative 'spec_helper'
require_relative '../lib/bits_computer'

describe BitsComputer do
  describe '#parse_hex_to_bits' do
    let(:bits_computer) { BitsComputer.new("D2FE28") }
    it 'parses and stores hex' do
      expected_bits = "110100101111111000101000"
      expect(bits_computer.parse_hex_to_bits).to eq expected_bits
    end
  end
end
