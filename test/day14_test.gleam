import day14
import gleeunit/should

pub fn day14_part1_test() {
  let test_input =
    "O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."

  day14.part1(test_input)
  |> should.equal(136)
}
// pub fn day14_part2_test() {
//   let test_input = ""

//   day14.part2(test_input)
//   |> should.equal(123)
// }
