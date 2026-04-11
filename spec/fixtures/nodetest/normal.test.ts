import assert from 'node:assert/strict';
import { test } from 'node:test';

test('synchronous passing test', (t) => {
  assert.strictEqual(1, 1);
});
