import t from 'tap'

const myObject = { a: 1, b: 2 }

t.test('test myObject', async t => {
  t.plan(2)
  t.equal(myObject.a, 1)
  t.matchOnly(myObject, { a: Number, b: Number })
})
