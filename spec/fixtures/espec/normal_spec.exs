defmodule SomeSpec do
  use ESpec
  it do: expect(1+1).to eq(2)
  it do: (1..3) |> should have 2
end
