<?php

describe("ToBe", function() {
    describe("::match()", function() {
        it("passes if true === true", function() {
            expect(true)->toBe(true);
        });
    });
});
