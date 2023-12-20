import day10
import gleeunit/should

pub fn day10_part1_test() {
  let test_input =
    "7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ"

  day10.part1(test_input)
  |> should.equal(8)
}

// pub fn day10_part2_test() {
//   let test_input = ""

//   day10.part2(test_input)
//   |> should.equal(123)
// }
