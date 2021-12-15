describe("Numbers", function()
  it("can be added", function()
    assert.True(1 + 1 == 2)
  end)

  -- Busted's `--filter` uses Lua patterns so magic characters need to be escaped with %.
  it("can add with magic ( ) . % + - * ? [ ^ $", function()
    assert.True(1 + 1 == 2)
  end)
end)
