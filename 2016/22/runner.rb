require_relative 'node'
nodes = File.open('input.txt').readlines[2..-1]
# nodes = File.open('sample_input.txt').readlines[2..-1]
nodes.map! do |node|
  Node.new(node)
end

def can_move(a, b)
  a.used <= b.avail
end

def viable(nodes, a)
  return 0 if a.empty?
  nodes.count { |b| can_move(a, b) }
end

# # Part 1
count = nodes.reduce(0) { |sum, node| sum + viable(nodes, node) }
p count

# Part 2
p grid_width = nodes.max_by { |node| node.pos[0] } .pos[0] + 1
p grid_height = nodes.max_by { |node| node.pos[1] } .pos[1] + 1
grid = Array.new(grid_height) { Array.new(grid_width) }
nodes.each do |node|
  x, y = node.pos
  grid[y][x] = node
end

grid.each do |row|
  string = row.map do |col|
    if col.empty?
      "_"
    elsif col.used < 80
      "."
    else
      '#'
    end
  end
  puts string.join
end