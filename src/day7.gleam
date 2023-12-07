import simplifile
import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/regex
import gleam/result
import gleam/map
import gleam/float

const filename = "inputs/day6"

const card_vals = [
  "A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2",
]

const hand_types = ["fives", "fours", "full", "threes", "twos", "pair", "high"]

type Hand {
  Hand(cards: List(String), bid: Int, hand_type: String)
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)

  io.debug(part1(contents))
  // io.debug(part2(contents))
}

pub fn part1(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(string.trim)
  |> list.map(to_hand)
  |> list.sort(by: compare_hands)
}

fn to_hand(hand: String) {
  let assert [cards, bid] = string.split(hand, " ")
  let assert Ok(bid) = int.parse(bid)
  let cards = string.to_graphemes(cards)
  Hand(cards: cards, bid: bid, hand_type: calculate_hand_type(cards))
}

fn calculate_hand_type(cards: List(String)) {
  let freqs =
    cards
    |> list.group(fn(x) { x })
    |> map.values()
    |> list.map(list.length)
    |> list.sort(by: int.compare)

  case freqs {
    [5] -> "fives"
    [1, 4] -> "fours"
    [2, 3] -> "full"
    [1, 1, 3] -> "threes"
    [1, 2, 2] -> "twos"
    [1, 1, 1, 2] -> "pair"
    [1, 1, 1, 1, 1] -> "high"
    _ -> panic
  }
}

fn compare_hands(h1: Hand, h2: Hand) {
  todo
}
