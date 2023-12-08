import day8
import gleeunit/should

pub fn day8_part1_test() {
  let test_input =
    "LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)"

  day8.part1(test_input)
  |> should.equal(6)
}
// pub fn day8_part2_test() {
//   let test_input =
//     "RL

// AAA = (BBB, CCC)
// BBB = (DDD, EEE)
// CCC = (ZZZ, GGG)
// DDD = (DDD, DDD)
// EEE = (EEE, EEE)
// GGG = (GGG, GGG)
// ZZZ = (ZZZ, ZZZ)"

//   day8.part2(test_input)
//   |> should.equal(123)
// }
