const tap = require('tape')

tap.test("parent", function(t) {
    t.test("subtest", function(t) {
        t.ok(1)
        t.end()
    })
    t.end()
})
