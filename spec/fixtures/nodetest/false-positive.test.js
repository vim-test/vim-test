const from = (value) => value;

const result = from('node:test');

if (!result) {
  throw new Error('unreachable');
}
