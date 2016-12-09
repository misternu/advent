import re



def decompress_v1(string):
  # BASE CASE
  if not string:
    return ""
  match = re.search(r'([^\(]*)\((\d+)x(\d+)\)(.*)', string)
  if not match:
    return string
  else:
    l, c = int(match.group(2)), int(match.group(3))
    before, after = match.group(1), match.group(4)
    return before + c * after[:l] + decompress(after[l:])

def decompress_v1_len(string):
  # BASE CASE
  if not string:
    return 0
  match = re.search(r'([^\(]*)\((\d+)x(\d+)\)(.*)', string)
  if not match:
    return len(string)
  else:
    l, c = int(match.group(2)), int(match.group(3))
    before, after = match.group(1), match.group(4)
    return len(before) + c * len(after[:l]) + decompress_v1_len(after[l:])

def decompress_v2_len(string):
  # BASE CASE
  if not string:
    return 0
  match = re.search(r'([^\(]*)\((\d+)x(\d+)\)(.*)', string)
  if not match:
    return len(string)
  else:
    l, c = int(match.group(2)), int(match.group(3))
    before, after = match.group(1), match.group(4)
    return len(before) + c * decompress_v2_len(after[:l]) + decompress_v2_len(after[l:])


string = open('input.txt', 'r').readline()
# print(len(string))
# print(decompress(""))
print(decompress_v2_len(string))

# print(decompress("X(8x2)(3x3)ABCY") == "X(3x3)ABC(3x3)ABCY")
# print(decompress("(6x1)(1x3)A") == "(1x3)A")
# print(decompress_v2_len("(27x12)(20x12)(13x14)(7x10)(1x12)A"))
# print(decompress_v2_len("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"))