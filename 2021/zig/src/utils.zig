const std = @import("std");

pub fn ReturnTypeOf(comptime callable_type: type) type {
    const info = @typeInfo(callable_type);
    return switch (info) {
        .Fn => info.Fn.return_type.?,
        .BoundFn => info.BoundFn.return_type.?,
        else => @compileError("unsupported type " ++ @typeName(callable_type)),
    };
}

pub fn ReadByLineIterator(comptime ReaderType: type) type {
    return struct {
        pub const MaxBufferSize: usize = 64 * 1024;

        allocator: *std.mem.Allocator,
        reader: ReaderType,
        last_read: ?[]const u8,

        pub fn deinit(self: @This()) void {
            if (self.last_read) |buf|
                self.allocator.free(buf);
        }

        /// Get next line from reader.
        /// Returns null only on EOF.
        pub fn next(self: *@This()) !?[]const u8 {
            if (self.last_read) |buf| {
                self.allocator.free(buf);
                self.last_read = null;
            }
            var e_line = self.reader.readUntilDelimiterAlloc(self.allocator, '\n', MaxBufferSize);
            if (e_line) |line| {
                self.last_read = line;
                return self.last_read;
            } else |err| {
                switch (err) {
                    error.EndOfStream => return null,
                    else => return err,
                }
            }
        }
    };
}

/// Get iterator over lines in reader.
/// Free with deinit().
pub fn readByLine(allocator: *std.mem.Allocator, file: anytype) ReadByLineIterator(ReturnTypeOf(@TypeOf(file.reader))) {
    return .{
        .allocator = allocator,
        .reader = file.reader(),
        .last_read = null,
    };
}

pub fn ReadByWordIterator(comptime ReaderType: type) type {
    return struct {
        reader: ReaderType,
        tokenIterator: ?std.mem.TokenIterator(u8),
        lineIterator: ReadByLineIterator(ReaderType),
        isStreamDone: bool = false,

        const Self = @This();

        /// Frees memory (all held in lineIterator)
        pub fn deinit(self: Self) void {
            self.lineIterator.deinit();
        }
        /// Get next space-delimited word from reader.
        /// Returns null only on EOF.
        pub fn next(self: *Self) !?[]const u8 {
            if (self.isStreamDone) {
                return null;
            }
            // if token iterator is not initalized yet, read in a line and tokenize
            if (self.tokenIterator == null) {
                if (try self.lineIterator.next()) |line| {
                    self.tokenIterator = std.mem.tokenize(u8, line, " ");
                }
            }
            // now we will read tokens (and lines) until we get a valid token, an error, or EOF
            while (!self.isStreamDone and self.tokenIterator != null) {
                // if the token is valid, return it
                if (self.tokenIterator.?.next()) |token| {
                    return token;
                }
                // otherwise, we have read all tokens on the current line
                // we now get a new line from line iterator
                if (try self.lineIterator.next()) |line| {
                    self.tokenIterator = std.mem.tokenize(u8, line, " ");
                }
                // if we got a null line, it's the EOF
                else break;
            }
            // if we found null line or tokenIterator itself is a null,
            // then we have hit the EndOfStream
            self.isStreamDone = true;
            return null;
        }

        /// Get next space-delimited word from reader parsed to integer.
        /// Returns null only on EOF.
        pub fn nextInt(self: *Self, comptime T: type) !?T {
            if (try self.next()) |nxt| {
                return try std.fmt.parseInt(T, nxt, 10);
            } else return null;
        }

        /// Get next space-delimited word from reader parsed to float.
        /// Returns null only on EOF.
        pub fn nextFloat(self: *Self, comptime T: type) !?T {
            if (try self.next()) |nxt| {
                return try std.fmt.parseFloat(T, nxt);
            } else return null;
        }
    };
}

/// Get iterator over space-delimited "words" in file.
/// Free with deinit().
pub fn readByWord(allocator: *std.mem.Allocator, file: anytype) ReadByWordIterator(ReturnTypeOf(@TypeOf(file.reader))) {
    var lineIterator = readByLine(allocator, file);
    return .{
        .reader = file.reader(),
        .tokenIterator = null,
        .lineIterator = lineIterator,
    };
}

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
/// General Purpose Allocator Pointer
pub const gpa = &gpa_impl.allocator;
