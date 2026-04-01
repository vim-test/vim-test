import assert from 'node:assert/strict';
import {
  test,
} from 'node:test';

test('multiline import is detected', () => {
  assert.strictEqual(1, 1);
});