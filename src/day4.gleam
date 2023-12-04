import gleam/string
import gleam/list
import gleam/int
import gleam/io
import gleam/set
import simplifile

const filename = "inputs/day4"

type Card {
  Card(card_id: Int, overlapping_nums: Int)
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)

  io.debug(part1(contents))
}

pub fn part1(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(to_cards)
  |> list.map(to_points)
  |> int.sum()
}

fn to_cards(input: String) {
  let assert ["Card " <> card_id, numbers] = string.split(input, ": ")
  let assert Ok(card_id) = int.parse(string.trim(card_id))
  let [winners, drawn] = string.split(numbers, " | ")

  let overlapping =
    set.intersection(as_numbers(winners), as_numbers(drawn))
    |> set.size()
  Card(card_id: card_id, overlapping_nums: overlapping)
}

fn as_numbers(numbers: String) {
  let assert Ok(n) =
    numbers
    |> string.split(" ")
    |> list.filter(fn(x) { !string.is_empty(x) })
    |> list.try_map(int.parse)

  set.from_list(n)
}

fn to_points(card: Card) {
  case card.overlapping_nums {
    0 -> 0
    x -> int.bitwise_shift_left(1, x - 1)
  }
}
