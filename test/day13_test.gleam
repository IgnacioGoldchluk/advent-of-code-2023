import day13
import gleeunit/should

pub fn day13_part1_test() {
  let test_input =
    "#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"

  day13.part1(test_input)
  |> should.equal(405)
}

pub fn day13_part2_test() {
  let test_input =
    "#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"

  day13.part2(test_input)
  |> should.equal(400)
}
