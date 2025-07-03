const std = @import("std");
const testing = std.testing;

test "numbers" {
    try testing.expect(1 == 1);
}

test "numbers 2" {
    try testing.expect(1 == 1);
}

test addOne {
    try testing.expect(addOne(1) == 2);
}

fn addOne(number: i32) i32 {
    return number + 1;
}
