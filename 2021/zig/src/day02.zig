const std = @import("std");
const utils = @import("utils.zig");
const readByWord = utils.readByWord;
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Alloc = std.mem.Allocator;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = &gpa_impl.allocator;

/// The first part of input: direction
const Dir = enum { forward, up, down };
/// The type of the second value. Overestimate size
const T : type = u128;

pub fn pt1() !void {
    var it = readByWord(gpa, std.io.getStdIn());
    defer it.deinit();

    var x : T = 0;
    var d : T = 0;

    var eo_dir = it.next();
    var eo_val = it.nextInt(T);
    while (try eo_dir) |dir| {
        const val : T = (try eo_val).?;
        switch (std.meta.stringToEnum(Dir, dir).?) {
            .forward => x += val,
            .up => d -= val,
            .down => d += val,
        }
        eo_dir = it.next(); 
        eo_val = it.nextInt(T);
    }
    print("Result: {d}\n", .{x * d});
}

pub fn pt2() !void {
    var it = readByWord(gpa, std.io.getStdIn());
    defer it.deinit();

    var x : T = 0;
    var aim : T = 0;
    var d : T = 0;

    var eo_dir = it.next();
    var eo_val = it.nextInt(T);
    while (try eo_dir) |dir| {
        const val : T = (try eo_val).?;
        switch (std.meta.stringToEnum(Dir, dir).?) {
            .forward => {x += val; d += (val * aim); },
            .up => aim -= val,
            .down => aim += val,
        }
        eo_dir = it.next(); 
        eo_val = it.nextInt(T);
    }
    print("Result: {d}\n", .{x * d});
}

pub fn main() !void {
    try pt2();
}
