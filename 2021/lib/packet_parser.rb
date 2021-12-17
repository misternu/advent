class PacketParser
  def initialize(bits = '')
    @bits = bits
    @index = 0
  end

  def self.parse(*args)
    new(*args).parse
  end

  def parse(i = 0)
    body, new_index = get_body(i)
    {
      version: get_version(i),
      type: get_type(i),
      body: body,
      new_index: new_index
    }
  end

  def get_body(i)
    return literal_body(i) if get_type(i) == 4
    nested_body(i)
  end

  def literal_body(i)
    i += 6
    output = ""
    reading = true
    while reading
      output += @bits[i+1..i+4]
      reading = @bits[i] == "1"
      i += 5
    end
    [output.to_i(2), i]
  end

  def nested_body(i)
    i += 6
    return nested_bit_count(i+1) if @bits[i] == "0"
    nested_packet_count(i+1)
  end

  def nested_bit_count(i)
    subpacket_length = @bits[i..i+14].to_i(2)
    i += 15
    subpacket_end = i + subpacket_length
    packets = []
    while i < subpacket_end
      data = parse(i)
      packets << data
      i = data[:new_index]
    end
    [packets, i]
  end

  def nested_packet_count(i)
    subpacket_count = @bits[i..i+10].to_i(2)
    i += 11
    packets = []
    while packets.count < subpacket_count
      data = parse(i)
      packets << data
      i = data[:new_index]
    end
    [packets, i]
  end

  def get_type_and_version(i)
    {
      version: get_version(i),
      type: get_type(i)
    }
  end

  def get_version(i)
    @bits[i..i+2].to_i(2)
  end

  def get_type(i)
    @bits[i+3..i+5].to_i(2)
  end
end
