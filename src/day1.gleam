import gleam/string
import gleam/list
import gleam/int
import gleam/io
import gleam/result
import simplifile

const filename = "inputs/day1"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

pub fn part1(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(extract_digits)
  |> list.map(build_2_digit_number)
  |> int.sum()
}

pub fn part2(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(parse_spelled_digits)
  |> list.map(extract_digits)
  |> list.map(build_2_digit_number)
  |> int.sum()
}

fn extract_digits(line: String) -> List(Int) {
  line
  |> string.to_graphemes()
  |> list.map(int.parse)
  |> result.values()
}

fn build_2_digit_number(digits: List(Int)) -> Int {
  let assert Ok(first) = list.first(digits)
  let assert Ok(last) = list.last(digits)

  first * 10 + last
}

fn parse_spelled_digits(line: String) -> String {
  // Keeping first and last letter too because some numbers have shared letters
  // for example "eightwo" should be "82"
  line
  |> string.replace("one", "o1e")
  |> string.replace("two", "t2o")
  |> string.replace("three", "t3e")
  |> string.replace("four", "f4r")
  |> string.replace("five", "f5e")
  |> string.replace("six", "s6x")
  |> string.replace("seven", "s7n")
  |> string.replace("eight", "e8t")
  |> string.replace("nine", "n9e")
}
