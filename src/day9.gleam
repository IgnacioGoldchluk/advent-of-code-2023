import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/int
import gleam/result
import gleam/pair

const filename = "inputs/day9"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

pub fn part1(input: String) {
  input
  |> parse()
  |> list.map(next_number)
  |> int.sum()
}

pub fn part2(input: String) {
  input
  |> parse()
  |> list.map(next_number_backwards)
  |> int.sum()
}

fn next_number_backwards(numbers: List(Int)) {
  // We have to do plus, minus, plus, minus, etc. because it alternates
  do_next_number_backwards(numbers, 0, 0)
}

fn do_next_number_backwards(numbers: List(Int), acc: Int, idx: Int) {
  let assert Ok(first) =
    list.first(numbers)
    |> result.try(fn(x) {
      case int.is_even(idx) {
        True -> Ok(x)
        False -> Ok(-x)
      }
    })

  case list.all(numbers, fn(x) { x == 0 }) {
    True -> acc
    False ->
      do_next_number_backwards(differences(numbers), acc + first, idx + 1)
  }
}

fn next_number(numbers: List(Int)) {
  do_next_number(numbers, 0)
}

fn do_next_number(numbers: List(Int), acc: Int) {
  let assert Ok(last) = list.last(numbers)

  case list.all(numbers, fn(x) { x == 0 }) {
    True -> acc
    False -> do_next_number(differences(numbers), acc + last)
  }
}

fn differences(numbers: List(Int)) {
  numbers
  |> list.window_by_2()
  |> list.map(fn(cont) { pair.second(cont) - pair.first(cont) })
}

fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.map(to_ints)
}

fn to_ints(input: String) {
  let assert Ok(ints) =
    input
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.all()

  ints
}
