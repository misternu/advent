# sample_input = ".^^.^.^^^^"
input = ".^.^..^......^^^^^...^^^...^...^....^^.^...^.^^^^....^...^^.^^^...^^^^.^^.^.^^..^.^^^..^^^^^^.^^^..^"

def next_row(row)
  prev = ['.'] + row + ['.']
  (1..row.length).map do |i|
    prev[i-1] == prev[i+1] ? '.' : '^'
  end
end

new_row = input.split('')
count = new_row.count('.')

gen_row = Proc.new do
  new_row = next_row(new_row)
  count += new_row.count('.')
end

# Part 1
rows1 = 40
(rows1 - 1).times { gen_row.call }
p count

# Part 2
rows2 = 400000
(rows2 - rows1).times { gen_row.call }
p count