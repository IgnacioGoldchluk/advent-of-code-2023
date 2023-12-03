import day3
import gleeunit/should

pub fn day3_part1_test() {
  let test_input =
    "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
  day3.part1(test_input)
  |> should.equal(4361)
}

pub fn day3_part2_test() {
  let test_input =
    "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
  day3.part2(test_input)
  |> should.equal(467_835)
}
