var test = require('tape');

test('math test', function (t) {
  t.plan(4);
  t.equal(4 + 2, 6, '4 + 2 should be 6');
  t.equal(4 - 2, 2, '4 - 2 should be 2');
  t.equal(4 * 2, 8, '4 * 2 should be 8');
  t.equal(4 / 2, 2, '4 / 2 should be 2');
});
