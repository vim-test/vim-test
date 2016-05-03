define(function (require) {
  var QUnit = require('intern!qunit');

  QUnit.module('Math');
  QUnit.test('adds two numbers', function (assert) {
    assert.equal(4 + 2, 6);
  });
  QUnit.test('subtracts two numbers', function (assert) {
    assert.equal(4 - 2, 2);
  });

  QUnit.module('Extra Math');
  QUnit.test('multiplies two numbers', function (assert) {
    assert.equal(4 * 2, 8);
  });
  QUnit.test('divides two numbers', function (assert) {
    assert.equal(4 / 2, 2);
  });
});
