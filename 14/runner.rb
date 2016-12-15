require 'digest'

# SALT = 'abc'
SALT = "ngcjuoqr"

def hex_for(index)
  digest = Digest::MD5.new
  digest.update(SALT + index.to_s)
  digest.hexdigest
end

def stretch_hex_for(index)
  digest = Digest::MD5.new
  digest.update(SALT + index.to_s)
  string = digest.hexdigest
  2016.times do
    digest = Digest::MD5.new
    digest.update(string)
    string = digest.hexdigest
  end
  string
end

def scan_for_valid(index, hexes)
  letters = hexes[index].scan(/(.)\1{2}/).flatten
  ((index+1)..(index+1001)).each do |i|
    fives = hexes[i].scan(/(.)\1{4}/).flatten
    if (letters[0..0] & fives).length > 0
      return true
    end
  end
  false
end

valid_indices = []
index = 0
# hexes = Hash.new { |h,k| h[k] = hex_for(k) }
hexes = Hash.new { |h,k| h[k] = stretch_hex_for(k) }

while valid_indices.length < 64
  if /(.)\1{2}/ =~ hexes[index]
    valid_indices << index if scan_for_valid(index, hexes)
    p valid_indices.length
  end
  index += 1
end

p valid_indices