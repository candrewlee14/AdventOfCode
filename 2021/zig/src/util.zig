const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = gpa_impl.allocator();

// Add utility functions here

pub fn NumLineIter(comptime T: type) type {
  return struct {
    const Self = @This();

    it: std.mem.SplitIterator(u8),

    pub fn init(buf: []const u8) Self {
      return Self{
        .it = split(u8, buf, "\n")
      };
    }
    pub fn next(self: *Self) ?T {
      if (self.it.next()) |line| {
        return parseInt(T, line, 0) catch return null;
      }
      return null;
    }
  };
}

pub fn WindowIter(comptime T: type, window_size: usize, comptime IterT: type) type {
  comptime assert(window_size > 1);
  return struct {
    const Self = @This();

    win: [window_size]T,
    it: IterT,

    pub fn init(it: IterT) ?Self {
      var window_it = Self{
        .win = undefined,
        .it = it,
      };
      var i : usize = 0; 
      while (i < window_size) : (i += 1) {
        if (window_it.it.next()) |val| {
          window_it.win[i] = val;
        } else {
          return null;
        }
      }
      return window_it;
    }

    pub fn next(self: *Self) ?T {
      if (self.it.next()) |val| {
        var i : usize = 1;
        while (i < window_size) : (i += 1) {
          self.win[i-1] = self.win[i];
        }
        self.win[window_size - 1] = val;
        return val; 
      }
      return null;
    }

    pub fn getWin(self: *Self) *const [window_size]T {
      return &self.win;
    }
  };
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
