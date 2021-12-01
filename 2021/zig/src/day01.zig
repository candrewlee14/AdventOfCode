const std = @import("std");
const utils = @import("utils.zig");
const readByWord = utils.readByWord;
const print = std.debug.print;
const ArrayList = std.ArrayList;
const gpa = utils.gpa;

/// Read stdin until no more input, bufSize is how many elements are in one window slice.
/// Returns the total number of increases in adjacent window slice totals
pub fn sonarSweep(comptime bufSize: usize) !u32 {
    var it = readByWord(gpa, std.io.getStdIn());
    defer it.deinit();
    // this will be our sliding window
    var q = ArrayList(u32).init(gpa);
    defer q.deinit();

    // try getting words until no more
    var increases: u32 = 0;
    var eo_cur_int = it.nextInt(u32);
    while (try eo_cur_int) |cur_int| : (eo_cur_int = it.nextInt(u32)) {
        if (q.items.len < bufSize) {
            try q.append(cur_int);
        } else {
            // Shift off first element and append new
            // This slides the window
            var n = q.orderedRemove(0);
            try q.append(cur_int);
            // check if increase happened
            if (cur_int > n) increases += 1;
        }
    }
    return increases;
}

pub fn pt1() !void {
    print("Result: {d}\n", .{try sonarSweep(1)});
}

pub fn pt2() !void {
    print("Result: {d}\n", .{try sonarSweep(3)});
}

pub fn main() !void {
    try pt2();
}
