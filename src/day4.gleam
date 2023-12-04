import gleam/string
import gleam/list
import gleam/int
import gleam/io
import gleam/set
import simplifile

const filename = "inputs/day4"

type Card {
  Card(card_id: Int, winners: set.Set(Int), drawn: set.Set(Int))
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)

  io.debug(part1(contents))
}

pub fn part1(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(to_cards)
  |> list.map(drawn_winners)
  |> list.map(to_points)
  |> int.sum()
}

fn to_cards(input: String) {
  let assert ["Card " <> card_id, numbers] = string.split(input, ": ")
  let assert Ok(card_id) = int.parse(string.trim(card_id))
  let [winners, drawn] = string.split(numbers, " | ")

  Card(card_id: card_id, winners: as_numbers(winners), drawn: as_numbers(drawn))
}

fn as_numbers(numbers: String) {
  let assert Ok(n) =
    numbers
    |> string.split(" ")
    |> list.filter(fn(x) { !string.is_empty(x) })
    |> list.try_map(int.parse)

  set.from_list(n)
}

fn drawn_winners(card: Card) {
  set.intersection(of: card.winners, and: card.drawn)
  |> set.size()
}

fn to_points(matches: Int) {
  case matches {
    0 -> 0
    x -> int.bitwise_shift_left(1, x - 1)
  }
}
