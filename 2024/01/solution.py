input = open("2024/01/input.txt", "r")

input = map(lambda line: map(int, line.strip().split('   ')), input.readlines())

a = []
b = []

for pair in input:
    a.append(pair[0])
    b.append(pair[1])

a.sort()
b.sort()

part_one = 0

for pair in zip(a, b):
    part_one += abs(pair[1] - pair[0])

print part_one

part_two = 0

for m in a:
    part_two += b.count(m) * m

print part_two
