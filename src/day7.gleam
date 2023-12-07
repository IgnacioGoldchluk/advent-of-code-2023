import simplifile
import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/map
import gleam/order

const filename = "inputs/day7"

const card_vals = [
  "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A",
]

const hand_types = ["high", "pair", "twos", "threes", "full", "fours", "fives"]

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
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(to_hand)
  |> list.sort(by: compare_hands)
  |> list.index_map(fn(idx, h) { { idx + 1 } * h.bid })
  |> int.sum()
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

fn index_of(element, a_list) {
  a_list
  |> list.index_map(fn(i, v) { #(i, v) })
  |> list.find_map(fn(i_v) {
    let assert #(i, v) = i_v
    case v {
      c if c == element -> Ok(i)
      _ -> Error(Nil)
    }
  })
}

fn compare_hand_types(ht1: String, ht2: String) {
  let assert Ok(v1) = index_of(ht1, hand_types)
  let assert Ok(v2) = index_of(ht2, hand_types)
  int.compare(v1, v2)
}

fn compare_card(c1, c2) {
  let assert Ok(cv1) = index_of(c1, card_vals)
  let assert Ok(cv2) = index_of(c2, card_vals)
  int.compare(cv1, cv2)
}

fn compare_cards_values(cs1: List(String), cs2: List(String)) {
  list.zip(cs1, cs2)
  |> list.fold_until(
    order.Eq,
    fn(_, cards) {
      let assert #(c1, c2) = cards
      case compare_card(c1, c2) {
        order.Eq -> list.Continue(order.Eq)
        lt_or_gt -> list.Stop(lt_or_gt)
      }
    },
  )
}

fn compare_hands(h1: Hand, h2: Hand) {
  let hand_cmp = compare_hand_types(h1.hand_type, h2.hand_type)
  case hand_cmp {
    order.Eq -> compare_cards_values(h1.cards, h2.cards)
    gt_or_lt -> gt_or_lt
  }
}
