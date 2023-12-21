import simplifile
import gleam/io
import gleam/list
import gleam/string
import gleam/int
import gleam/pair

const filename = "inputs/day13"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

fn rows_cols(input: String) {
  let rows =
    string.split(input, "\n")
    |> list.map(string.to_graphemes)
  let cols = list.transpose(rows)

  #(rows, cols)
}

fn lines_diff(l1, l2) {
  list.zip(l1, l2)
  |> list.filter(fn(x) { pair.first(x) != pair.second(x) })
  |> list.length()
}

fn does_reflect(left, right, lines, expected_diff, current_diff) -> Bool {
  let total_lines = list.length(lines)
  case total_lines {
    _ if right >= total_lines || left < 0 -> expected_diff == current_diff
    _ -> {
      let assert Ok(l1) = list.at(lines, left)
      let assert Ok(l2) = list.at(lines, right)

      let new_diff = lines_diff(l1, l2) + current_diff
      case new_diff {
        d if d > expected_diff -> False
        _ -> does_reflect(left - 1, right + 1, lines, expected_diff, new_diff)
      }
    }
  }
}

fn reflection_value(lines: List(List(String)), expected_diff: Int) {
  list.range(0, list.length(lines) - 2)
  |> list.filter(fn(start) {
    does_reflect(start, start + 1, lines, expected_diff, 0)
  })
  |> list.first()
}

fn reflection(rows_cols, expected_diff) {
  let assert #(rows, cols) = rows_cols
  case reflection_value(rows, expected_diff) {
    Ok(val) -> 100 * { val + 1 }
    _ -> {
      // Guaranteed to succeed
      let assert Ok(val) = reflection_value(cols, expected_diff)
      val + 1
    }
  }
}

pub fn part1(input: String) {
  input
  |> string.split("\n\n")
  |> list.map(rows_cols)
  |> list.map(fn(p) { reflection(p, 0) })
  |> int.sum()
}

pub fn part2(input: String) {
  input
  |> string.split("\n\n")
  |> list.map(rows_cols)
  |> list.map(fn(p) { reflection(p, 1) })
  |> int.sum()
}
