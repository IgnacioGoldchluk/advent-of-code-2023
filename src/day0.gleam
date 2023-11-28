import gleam/string
import gleam/list
import gleam/int
import gleam/io
import simplifile

const filename = "inputs/day0"

pub fn day0() {
  let assert Ok(contents) = simplifile.read(filename)

  io.debug(sum_of_numbers(contents))
  io.debug(sum_of_squares(contents))
}

pub fn sum_of_numbers(contents) {
  contents
  |> string.split(on: "\n")
  |> list.map(fn(number) {
    case int.parse(number) {
      Ok(x) -> x
      _ -> panic
    }
  })
  |> int.sum()
}

pub fn sum_of_squares(contents) {
  contents
  |> string.split(on: "\n")
  |> list.map(fn(number) {
    case int.parse(number) {
      Ok(x) -> x
      _ -> panic
    }
  })
  |> list.map(fn(x) { x * x })
  |> int.sum()
}
