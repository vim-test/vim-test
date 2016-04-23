define(function (require) {
  var bdd = require('intern!bdd');
  var assert = require('intern/chai!assert');

  bdd.describe('Math', function () {
    bdd.it('adds two numbers', function () {
      assert.equal(4 + 2, 6);
    });

    bdd.it('subtracts two numbers', function () {
      assert.equal(4 - 2, 2);
    });

    bdd.describe('Extra Math', function () {
      bdd.it('multiplies two numbers', function () {
        assert.equal(4 * 2, 8);
      });

      bdd.it('divides two numbers', function () {
        assert.equal(4 / 2, 2);
      });
    });
  });
});
