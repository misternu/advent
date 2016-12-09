class BadChecksum < StandardError
end

class Room
  attr_reader :name, :id, :checksum
  def initialize(string)
    match = /(\D*)-(\d+)\[(.+)\]/.match(string)
    @name = match[1]
    @id = match[2].to_i
    @checksum = match[3]
  end

  def valid
    freq = Hash.new(0)
    name.gsub('-','').split('').each { |c| freq[c] += 1 }
    # Sort by value descending, then by key ascending
    sorted = freq.sort { |k,v| [ v[1], k[0] ] <=> [ k[1], v[0] ] }
    sorted[0..4].map(&:first).join == @checksum
  end

  def decode
    alpha = ("a".."z").to_a
    @name.split('-').map do |word|
      word.split('').map do |c|
        alpha[(alpha.index(c) + id) % 26]
      end .join
    end .join(' ')
  end
end