require_relative 'spec_helper'
require_relative '../lib/packet_parser'

sample_input_1 =
describe PacketParser do
  let(:packet_parser) { PacketParser.new(input) }
  describe '#parse' do
    context 'literal packet' do
      let(:input) { "110100101111111000101000" }
      it 'parses the literal packet' do
        expected_packet = {
          version: 6,
          type: 4,
          body: 2021,
          new_index: 21
        }
        expect(packet_parser.parse).to eq expected_packet
      end
    end
    context 'packet with subpacket length' do
      let(:input) { "00111000000000000110111101000101001010010001001000000000" }
      it 'parses the packet and subpackets' do
        expected_packet = {
          version: 1,
          type: 6,
          body: [
            {
              version: 6,
              type: 4,
              body: 10,
              new_index: 33
            },
            {
              version: 2,
              type: 4,
              body: 20,
              new_index: 49
            }
          ],
          new_index: 49
        }
        packet = packet_parser.parse
        packet.keys.each do |k|
          expect(packet[k]).to eq expected_packet[k]
        end
      end
    end
    context 'packet with subpacket count' do
      let(:input) { "11101110000000001101010000001100100000100011000001100000" }
      it 'parses the packet and subpackets' do
        expected_packet = {
          version: 7,
          type: 3,
          body: [
            {version: 2, type: 4, body: 1, new_index: 29},
            {version: 4, type: 4, body: 2, new_index: 40},
            {version: 1, type: 4, body: 3, new_index: 51}
          ],
          new_index: 51
        }
        packet = packet_parser.parse
        packet.keys.each do |k|
          expect(packet[k]).to eq expected_packet[k]
        end
      end
    end
  end
end
