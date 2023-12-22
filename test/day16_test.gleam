import day16
import gleeunit/should

pub fn day16_part1_test() {
  let test_input =
    ".|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|...."

  day16.part1(test_input)
  |> should.equal(46)
}

pub fn day16_part2_test() {
  let test_input =
    ".|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|...."

  day16.part2(test_input)
  |> should.equal(51)
}
