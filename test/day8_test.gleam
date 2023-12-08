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

pub fn day8_part2_test() {
  let test_input =
    "LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)"

  day8.part2(test_input)
  |> should.equal(6)
}
