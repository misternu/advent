def dragon(string)
  a = string
  b = string.reverse.gsub(/[01]/, '0' => '1', '1' => '0')
  p string.length
  a + "0" + b
end

def dragon_size(n, l)
  return n if n > l
  dragon_size(n*2 + 1, l)
end

def checksum(string)
  sum = string.split("").each_slice(2).map do |a, b|
    a == b ? "1" : "0"
  end .join
  p sum.length
  return sum unless sum.length % 2 == 0
  return checksum(sum)
end

def num_recursions(n)
  return n unless n % 2 == 0
  num_recursions(n/2)
end


# hd_length = 272
hd_length = 35651584
starting_data = "11100010111110100"
data = dragon(starting_data)

until data.length > hd_length
  data = dragon(data)
end

p checksum(data[0...hd_length])
