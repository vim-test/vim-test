import gleeunit
import gleeunit/should

pub fn add_one(number: i32) -> i32 {
  number + 1
}

pub fn add_one_test() {
  add_one(1)
  |> should.equal(2)
}

pub fn add_one_twice_test() {
  add_one(1)
  |> add_one
  |> should.equal(3)
}

