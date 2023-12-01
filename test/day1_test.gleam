import day1
import gleeunit/should

pub fn day1_part1_test() {
  let test_input =
    "1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet"

  day1.part1(test_input)
  |> should.equal(142)
}

pub fn day1_part2_test() {
  let test_input =
    "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"

  day1.part2(test_input)
  |> should.equal(281)
}
