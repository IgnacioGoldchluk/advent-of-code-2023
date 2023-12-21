import simplifile
import gleam/io
import gleam/list
import gleam/string
import gleam/int
import gleam/pair

const filename = "inputs/day13"

type Pattern {
  Pattern(rows: List(List(String)), cols: List(List(String)))
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  // io.debug(part2(contents))
}

fn rows_cols(input: String) {
  let rows =
    string.split(input, "\n")
    |> list.map(string.to_graphemes)
  let cols = list.transpose(rows)
  Pattern(rows: rows, cols: cols)
}

fn are_lines_equal(l1, l2) {
  list.zip(l1, l2)
  |> list.all(fn(x) { pair.first(x) == pair.second(x)})
}

fn does_reflect(left, right, lines) -> Bool {
  let total_lines = list.length(lines)
  case total_lines {
    _ if right >= total_lines -> True
    _ if left < 0 -> True
    _ -> {
      let assert Ok(l1) = list.at(lines, left)
      let assert Ok(l2) = list.at(lines, right)

      case are_lines_equal(l1, l2) {
        True -> does_reflect(left - 1, right + 1, lines)
        False -> False
      }
    }
  }
}

fn reflection_value(lines: List(List(String))) {
  list.range(0, list.length(lines) - 2)
  |> list.filter(fn(start) { does_reflect(start, start + 1, lines) })
  |> list.first()
}

fn reflection(pattern: Pattern) {
  let assert Pattern(rows: rows, cols: cols) = pattern
  case reflection_value(rows) {
    Ok(val) -> 100 *  { val + 1 }
    _ -> {
      // Guaranteed to succeed
      let assert Ok(val) = reflection_value(cols)
      val + 1
    }
  }
}

pub fn part1(input: String) {
  input
  |> string.split("\n\n")
  |> list.map(rows_cols)
  |> list.map(reflection)
  |> int.sum()
}

// pub fn part2(input: String) {
//   todo
// }
