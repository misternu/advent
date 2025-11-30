with open('2024/09/input.txt', 'r') as file:
    input = file.read().rstrip()

i = 0
i_len = int(input[i])
j = len(input)-1
j_len = int(input[j])

a = 0
pos = 0
in_gap = False
while i < j:
    if not in_gap:
        a += pos * (i//2)
    else:
        a += pos * (j//2)
        j_len -= 1
    i_len -= 1

    if j_len == 0:
        j -= 2
        j_len = int(input[j])

    if i_len == 0:
        in_gap = not in_gap
        i += 1
        i_len = int(input[i])

    pos += 1

if not in_gap:
    for _ in range(j_len):
        a += pos * (i//2)
        pos += 1
else:
    for _ in range(j_len):
        a += pos * (j//2)
        pos += 1

print(a)
