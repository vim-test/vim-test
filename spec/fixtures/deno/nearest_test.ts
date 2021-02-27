import { assertEquals } from 'https://deno.land/std@0.88.0/testing/asserts.ts'

const test = Deno.test

test('Simple nearest', () => {
  const x = 2 + 2
  assertEquals(x, 4)
})

Deno.test('Deno module nearest', () => {
  const x = 2 + 2
  assertEquals(x, 4)
})

Deno.test({
  name: 'name key test nearest',
  fn() {
    const x = 2 + 2
    assertEquals(x, 4)
  }
})

const sampleTest = () => {
  const x = 2 + 2
  assertEquals(x, 4)
}

Deno.test({ name: 'one line name key test nearest', fn: sampleTest })
