from mamba import description, context, it
from expects import expect, equal

with description('Addition') as self:
  with it('adds two numbers'):
    expect(1 + 1).to(equal(2))
