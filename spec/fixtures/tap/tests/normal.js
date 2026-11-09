import t from 'tap'
import { myThing } from '../src/whatever.js'

t.test('this is a child test', t => {
  t.pass('this passes')
  t.fail('this fails')
  t.ok(myThing, 'this passes if truthy')
  t.equal(myThing, 5, 'this passes if the values are equal')
  t.match(myThing, {
    property: String,
  }, 'this passes if myThing.property is a string')
  // call this when you're done
  t.end()
})
