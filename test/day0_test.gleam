import day0
import gleeunit/should


pub fn day0_part1_test() {
  day0.sum_of_numbers("1\n2\n3")
  |> should.equal(6)
}

pub fn day0_part2_test() {
  day0.sum_of_squares("1\n2\n3")
  |> should.equal(14)
}