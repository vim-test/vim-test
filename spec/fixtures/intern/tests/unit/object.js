define(function (require) {
  var registerSuite = require('intern!object');
  var assert = require('intern/chai!assert');

  registerSuite({name: 'Math',

    'adds two numbers': function () {
      assert.equal(4 + 2, 6);
    },

    'subtracts two numbers': function () {
      assert.equal(4 - 2, 2);
    },

    'Extra Math': {

      'multiplies two numbers': function () {
        assert.equal(4 * 2, 8);
      },

      'divides two numbers': function () {
        assert.equal(4 / 2, 2);
      }

    }

  });
});
