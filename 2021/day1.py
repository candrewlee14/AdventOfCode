file = open('./data/day01.txt')
lines = file.readlines()
prev = None
increases = 0
a = None
for i in range(len(lines) - 2):
    n = int(lines[i].strip()) + int(lines[i+1].strip()) + int(lines[i+2].strip())
    if prev == None:
        prev = n
        continue
    if n > prev:
        increases += 1
    prev = n
print("Increases: ", increases)
