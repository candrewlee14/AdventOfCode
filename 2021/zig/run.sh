#!/usr/bin/env sh

if [ -z "$1" ]
then
    echo "Must supply a day #\n"
    exit
fi

DAYNUM=`printf "%02d" $1`
echo "Running day $DAYNUM...\n"
cat ../data/day$DAYNUM.txt | zig build day$DAYNUM
