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

pub fn day10_part2_test() {
  let test_input =
    ".F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ..."

  day10.part2(test_input)
  |> should.equal(8)
}
