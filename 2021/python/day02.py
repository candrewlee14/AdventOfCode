#!/usr/bin/env python3
file = open('../data/day02.txt')
lines = file.readlines()

x = 0
d = 0
aim = 0
for line in lines:
    pieces =  line.strip().split(' ')
    if pieces[0] == "forward":
        forw = int(pieces[1])
        x += forw
        d += forw * aim
    elif pieces[0] == "down":
        aim += int(pieces[1])
    elif pieces[0] == "up":
        aim -= int(pieces[1])


print("Res: ", x * d)
