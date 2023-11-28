import gleam/string
import gleam/result
import gleam/list
import gleam/int
import gleam/io
import simplifile

const filename = "inputs/day0"

pub fn day0() {
  let contents =
    simplifile.read(filename)
    |> result.unwrap("")

  io.debug(sum_of_numbers(contents))
  io.debug(sum_of_squares(contents))
}

pub fn sum_of_numbers(contents) {
  contents
  |> string.split(on: "\n")
  |> list.map(fn(number) {
    int.parse(number)
    |> result.unwrap(0)
  })
  |> int.sum()
}

pub fn sum_of_squares(contents) {
  contents
  |> string.split(on: "\n")
  |> list.map(fn(number) {
    int.parse(number)
    |> result.unwrap(0)
    |> fn(x) { x * x }
  })
  |> int.sum()
}
