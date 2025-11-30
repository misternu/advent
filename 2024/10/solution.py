with open('2024/10/input.txt', 'r') as file:
    input = list(map(str.rstrip, file.readlines()))

height = len(input)
width = len(input[0])

grid = {}
for i in range(height):
    for j in range(width):
        grid[(j,i)] = int(input[i][j])

def neighbor_pos(point, width, height):
    x, y = point
    dirs = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    return [(dx, dy) for dx, dy in dirs if dx >= 0 and dy >= 0 and dx < width and dy < height]

a = 0

for y in range(height):
    for x in range(width):
        if grid[(x, y)] != 0:
            continue

        queue = [(x, y)]
        visited = {}

        while len(queue) > 0:
            pos = queue.pop(0)
            if visited.get(pos):
                continue
            visited[pos] = True
            if grid.get(pos) == 9:
                a += 1
                continue
            for n_pos in neighbor_pos(pos, width, height):
                if grid.get(n_pos) == grid.get(pos) + 1:
                    queue.append(n_pos)

print(a)

b = 0
for y in range(height):
    for x in range(width):
        if grid[(x, y)] != 0:
            continue

        queue = [(x, y)]

        while len(queue) > 0:
            pos = queue.pop(0)
            if grid.get(pos) == 9:
                b += 1
                continue
            for n_pos in neighbor_pos(pos, width, height):
                if grid.get(n_pos) == grid.get(pos) + 1:
                    queue.append(n_pos)

print(b)
