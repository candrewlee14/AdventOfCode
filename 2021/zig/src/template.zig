const std = @import("std");
const utils = @import("utils.zig");
const readByWord = utils.readByWord;
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Alloc = std.mem.Allocator;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = &gpa_impl.allocator;

pub fn pt1() !void {
    // set up alloc
    var it = readByWord(gpa, std.io.getStdIn());
    defer it.deinit();
    // set up arraylist
    var list = ArrayList(u8).init(gpa);
    defer list.deinit();

    var res : u128 = 0;
    // iterate all words of input
    var eo_word = it.next();
    while (try eo_word) |word| {
        res += 1;
        eo_word = it.next(); 
    }
    print("Result: {d}\n", .{res});
}

pub fn pt2() !void {
}

pub fn main() !void {
    try pt1();
}
