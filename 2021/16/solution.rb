require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt').first
sample_1 = "D2FE28"
sample_2 = "38006F45291200"
sample_3 = "EE00D40C823060"
# MemoryProfiler.start(allow_files: __FILE__)
input = sample_3
hexes = {
  "0" => "0000",
  "1" => "0001",
  "2" => "0010",
  "3" => "0011",
  "4" => "0100",
  "5" => "0101",
  "6" => "0110",
  "7" => "0111",
  "8" => "1000",
  "9" => "1001",
  "A" => "1010",
  "B" => "1011",
  "C" => "1100",
  "D" => "1101",
  "E" => "1110",
  "F" => "1111"
}



# Part 1
bits = input.split('').map { |c| hexes[c] } .join
def parse(string, return_data = true)
  version = string[0..2].to_i(2)
  type    = string[3..5].to_i(2)
  if type == 4
    # literal
    output = ""
    i = 6
    reading = true
    while reading
      output += string[i+1..i+4]
      reading = string[i] == "1"
      i += 5
    end
    literal = output.to_i(2)
    if return_data
      { version: version, type: type, body: literal, length: i }
    else
      literal
    end
  else
    type_id = string[6]
    if type_id == "0"
      subpacket_length = string[7..(7+14)].to_i(2)
      i = 22
      subpacket_end = 21 + subpacket_length
      packets = []
      while i < subpacket_end
        data = parse(string[i..-1], true)
        packets << data
        i += data[:length]
      end
      if return_data
        { version: version, type: type, body: packets, length: i } 
      else
        packets
      end
    else
      subpacket_count = string[7..(7+10)].to_i(2)
      i = 18
      count = 0
      packets = []
      while count < subpacket_count
        data = parse(string[i..-1], true)
        packets << data
        count += 1
        i += data[:length]
      end
      if return_data
        { version: version, type: type, body: packets, length: i } 
      else
        packets
      end
    end
  end
end
def sum_versions(data)
  return data[:version] if data[:body].is_a?(Integer)
  data[:version] + data[:body].sum { |d| sum_versions(d) }
end
p data = parse(bits)
a = sum_versions(data)

# Part 2
def operate(data)
  case data[:type]
  when 0
    data[:body].sum { |p| operate(p) }
  when 1
    numbers = data[:body].map { |p| operate(p) }
    numbers.reduce(&:*)
  when 2
    numbers = data[:body].map { |p| operate(p) }
    numbers.min
  when 3
    numbers = data[:body].map { |p| operate(p) }
    numbers.max
  when 4
    data[:body]
  when 5
    a, b = data[:body].map { |p| operate(p) }
    a > b ? 1 : 0
  when 6
    a, b = data[:body].map { |p| operate(p) }
    a < b ? 1 : 0
  when 7
    a, b = data[:body].map { |p| operate(p) }
    a == b ? 1 : 0
  end
end
sample_sum = "C200B40A82"
sample_product = "04005AC33890"
sample_minimum = "880086C3E88112"
sample_maximum = "CE00C43D881120"
sample_less_than = "D8005AC2A8F0"
sample_greater_than = "F600BC2D8F"
sample_equal = "9C005AC2F8F0"
sample_complex = "9C0141080250320F1802104A08"
# input = sample_complex
bits = input.split('').map { |c| hexes[c] } .join
data = parse(bits)
b = operate(data)



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
