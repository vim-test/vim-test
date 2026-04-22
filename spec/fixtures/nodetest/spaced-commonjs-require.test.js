const assert = require( 'node:assert/strict' );
const test = require( 'node:test' );

test('commonjs require with spaces is detected', () => {
  assert.strictEqual(1, 1);
});
