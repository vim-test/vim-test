define(function (require) {
  var tdd = require('intern!tdd');
  var assert = require('intern/chai!assert');

  tdd.suite('Math', function () {
    tdd.test('adds two numbers', function () {
      assert.equal(4 + 2, 6);
    });

    tdd.test('subtracts two numbers', function () {
      assert.equal(4 - 2, 2);
    });

    tdd.suite('Extra Math', function () {
      tdd.test('multiplies two numbers', function () {
        assert.equal(4 * 2, 8);
      });

      tdd.test('divides two numbers', function () {
        assert.equal(4 / 2, 2);
      });
    });
  });
});
