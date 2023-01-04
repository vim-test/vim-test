var assert = require('core-assert')
var Dog = require('../../lib/dog')

module.exports = {
  beforeEach: function () {
    this.subject = new Dog('Sam')
  },
  bark: {
    once: function () {
      assert.deepEqual(this.subject.bark(1), ['Woof #0'])
    },
    twice: function () {
      assert.deepEqual(this.subject.bark(2), ['Woof #0', 'Woof #1'])
    }
  },
  tag: {
    frontSaysName: function () {
      assert.equal(this.subject.tag('front'), 'Hi, I am Sam')
    },
    backSaysAddress: function () {
      assert.equal(this.subject.tag('back'), 'And here is my address')
    }
  }
}