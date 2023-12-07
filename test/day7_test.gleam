import day7
import gleeunit/should

pub fn day7_part1_test() {
  let test_input =
    "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"

  day7.part1(test_input)
  |> should.equal(6440)
}

pub fn day7_part2_test() {
  let test_input =
    "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"

  day7.part2(test_input)
  |> should.equal(5905)
}
