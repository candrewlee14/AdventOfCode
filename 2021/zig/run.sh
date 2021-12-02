#!/usr/bin/env sh

DAYNUM=`printf "%02d" $1`
echo "Running day $DAYNUM...\n"
cat ../data/day$DAYNUM.txt | zig build day$DAYNUM
