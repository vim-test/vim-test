import t from 'tap'

const myObject = { a: 1, b: 2 }

t.test('test myObject', t => {
  t.test('nested child test', async t => {
    t.equal(myObject.a, 1)
    t.matchOnly(myObject, { a: Number, b: Number })
    t.end()
  })
  t.end()
})
