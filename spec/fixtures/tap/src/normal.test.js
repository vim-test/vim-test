import t from 'tap'
import { myThing } from './whatever.js'

t.test('async tests work like you would expect', async t => {
  t.equal(await myThing(), 'whatever')
  // don't have to call t.end(), it'll just end when the
  // async stuff is all resolved.
})
