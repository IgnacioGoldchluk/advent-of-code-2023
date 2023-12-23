import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/int

const filename = "inputs/day15"
pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  // io.debug(part2(contents))
}

fn to_codes(input: String) -> List(Int) {
  input
  |> string.replace("\n", "")
  |> string.split(",")
  |> list.map(hash_value)
}

fn hash_value(code: String) {
  code
  |> string.to_utf_codepoints()
  |> list.map(string.utf_codepoint_to_int)
  |> list.fold(0, fn(acc, char) {
    let assert Ok(new) = acc
    |> int.add(char)
    |> int.multiply(17)
    |> int.modulo(256)

    new
  })
}

pub fn part1(input: String) {
  input
  |> to_codes()
  |> int.sum()
}

// pub fn part2(input: String) {
//   todo
// }