INSTRUCTIONS = File.open('input.txt').readlines.map(&:strip)

def swap(string, x, y)
  letters = string.split('')
  letters[x], letters[y] = letters[y], letters[x]
  letters.join
end

def swap_letter(string, x, y)
  nx = string.index(x)
  ny = string.index(y)
  swap(string, nx, ny)
end

def rotate_left(string, n)
  actual = n % string.length
  string[actual..-1] + string[0...actual]
end

def rotate_right(string, n)
  actual = n % string.length
  rotate_left(string, string.length - actual)
end

def rotate_based(string, c)
  index = string.index(c)
  rotate_right(string, index + (index >= 4 ? 2 : 1))
end

def reverse_section(string, x, y)
  letters = string.split('')
  (letters[0...x] + letters[x..y].reverse + letters[(y+1)..-1]).join
end

def move_to(string, x, y)
  letters = string.split('')
  char = letters.delete_at(x)
  letters.insert(y, char)
  letters.join
end

def run(input)
  string = input
  INSTRUCTIONS.each do |i|
    if /swap pos/ =~ i
      x, y = /ion (\d+).*ion (\d+)/.match(i).captures.map(&:to_i)
      string = swap(string, x, y)
    elsif /swap let/ =~ i
      x, y = /ter (\w{1}).*ter (\w{1})/.match(i).captures
      string = swap_letter(string, x, y)
    elsif /rotate lef/ =~ i
      n = /(\d+)/.match(i).captures.first.to_i
      string = rotate_left(string, n)
    elsif /rotate rig/ =~ i
      n = /(\d+)/.match(i).captures.first.to_i
      string = rotate_right(string, n)
    elsif /rotate bas/ =~ i
      c = /ter (\w{1})/.match(i).captures.first
      string = rotate_based(string, c)
    elsif /reverse pos/ =~ i
      x, y = /ons (\d+).*ugh (\d+)/.match(i).captures.map(&:to_i)
      string = reverse_section(string, x, y)
    elsif /move pos/ =~ i
      x, y = /ion (\d+).*ion (\d+)/.match(i).captures.map(&:to_i)
      string = move_to(string, x, y)
    end
  end
  string
end

# Part 1
input = "abcdefgh"
puts run(input)

# Part 2
input = "fbgdceah"
input.split('').permutation(8).each do |perm|
  guess = perm.join
  attempt = run(guess)
  if attempt == input
    puts guess
    break
  end
end