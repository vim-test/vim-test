import assert from 'node:assert/strict';
import {
  before,
  test,
  after,
} from 'node:test';

test('multiline import with multiple names is detected', () => {
  assert.strictEqual(typeof before, 'function');
  assert.strictEqual(typeof after, 'function');
});
