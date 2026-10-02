import test, {type TestContext} from 'node:test';

test('this is a test', (t: TestContext) => {
  t.assert.ok('it works')
})
