import day6
import gleeunit/should

pub fn day6_part1_test() {
  let test_input =
    "Time:      7  15   30
Distance:  9  40  200"

  day6.part1(test_input)
  |> should.equal(288)
}

pub fn day6_part2_test() {
  let test_input =
    "Time:      7  15   30
Distance:  9  40  200"

  day6.part2(test_input)
  |> should.equal(71_503)
}
