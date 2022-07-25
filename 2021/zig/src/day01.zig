const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../../data/day01.txt");

fn part1() !isize {
  var it = split(u8, data, "\n");
  var prev_num : isize = -1;
  var inc_count : isize = -1;
  while (it.next()) |line| {
    const num = parseInt(isize, line, 0) catch return inc_count;
    if (num > prev_num) {
      inc_count += 1;
    }
    prev_num = num;
  }
  return inc_count;
}

fn part2() !usize {
  var inc_count : usize = 0;
  var it = util.NumLineIter(usize).init(data);
  const win_size = 3;
  var window_it = util.WindowIter(usize, win_size, util.NumLineIter(usize)).init(it) orelse unreachable;
  var sum : usize = 0;
  for (window_it.getWin()) |val| {
    sum += val;
  }
  var prev_sum = sum;
  var prev_num : usize = window_it.getWin()[0];
  while (window_it.next()) |new_val| {
    sum = sum + new_val - prev_num;
    prev_num = window_it.getWin()[0];
    if (sum > prev_sum) {
      inc_count += 1;
    }
    prev_sum = sum;
  }
  return inc_count;
}

pub fn main() !void {
  const p1 = part1();
  print("Part 1: {d}\n", .{p1});
  const p2 = part2();
  print("Part 2: {d}\n", .{p2});
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;
