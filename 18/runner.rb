# sample_input = ".^^.^.^^^^"
input = ".^.^..^......^^^^^...^^^...^...^....^^.^...^.^^^^....^...^^.^^^...^^^^.^^.^.^^..^.^^^..^^^^^^.^^^..^"

def next_row(row)
  prev = ['.'] + row + ['.']
  (1..row.length).map do |i|
    prev[i-1] == prev[i+1] ? '.' : '^'
  end
end

# Part 1
rows = [input.split('')]
39.times do
  rows << next_row(rows.last)
end
p rows.flatten.count('.')

# Part 2
count = input.count('.')
new_row = input.split('')
399999.times do
  new_row = next_row(new_row)
  count += new_row.count('.')
end
p count