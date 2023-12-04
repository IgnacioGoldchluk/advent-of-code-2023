import gleam/string
import gleam/list
import gleam/int
import gleam/io
import gleam/set
import gleam/map
import gleam/option
import simplifile

const filename = "inputs/day4"

type Card {
  Card(card_id: Int, overlapping_nums: Int)
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)

  io.debug(part1(contents))
  io.debug(part2(contents))
}

pub fn part1(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(to_cards)
  |> list.map(to_points)
  |> int.sum()
}

pub fn part2(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(to_cards)
  |> accumulate_cards()
  |> map.values()
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
  numbers
  |> string.split(" ")
  |> list.filter(fn(x) { !string.is_empty(x) })
  |> set.from_list()
}

fn to_points(card: Card) {
  case card.overlapping_nums {
    0 -> 0
    x -> int.bitwise_shift_left(1, x - 1)
  }
}

fn accumulate_cards(cards: List(Card)) {
  let count =
    cards
    |> list.map(fn(c) { #(c.card_id, 1) })
    |> map.from_list()

  cards
  |> list.fold(
    from: count,
    with: fn(acc, card) {
      let assert Ok(copies) = map.get(acc, card.card_id)

      card
      |> copies_range()
      |> list.fold(
        acc,
        fn(acc, idx) {
          map.update(
            acc,
            idx,
            fn(val) {
              case val {
                option.Some(i) -> i + copies
                _ -> panic
              }
            },
          )
        },
      )
    },
  )
}

fn copies_range(card: Card) {
  case card.overlapping_nums {
    0 -> list.new()
    x -> list.range(card.card_id + 1, card.card_id + x)
  }
}
