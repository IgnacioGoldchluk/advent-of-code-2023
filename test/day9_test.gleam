import day9
import gleeunit/should

pub fn day9_part1_test() {
  let test_input =
    "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"

  day9.part1(test_input)
  |> should.equal(114)
}

pub fn day9_part2_test() {
  let test_input =
    "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"

  day9.part2(test_input)
  |> should.equal(2)
}
