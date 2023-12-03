import simplifile
import gleam/io
import gleam/int
import gleam/string
import gleam/map
import gleam/result
import gleam/list

const filename = "inputs/day3"

const digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

const non_special = [".", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

type NumberInGrid {
  NumberInGrid(number: Int, coords: List(#(Int, Int)))
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  // io.debug(part2(contents))
}

pub fn part1(input: String) {
  let chars_with_coords = to_coords_chars(input)
  let numbers = parse_numbers(chars_with_coords)
  let special_chars =
    chars_with_coords
    |> list.filter(fn(x) { !list.contains(non_special, x.1) })
    |> map.from_list()

  numbers
  |> list.filter(fn(x) { adjacent_to_chars(x.coords, special_chars) })
  |> list.map(fn(x) { x.number })
  |> int.sum()
}

pub fn part2(input: String) {
  let chars_with_coords = to_coords_chars(input)
  let number = parse_numbers(chars_with_coords)
  let special_chars =
    chars_with_coords
    |> list.filter(fn(x) { !list.contains(non_special, x.1) })
    |> map.from_list()
}

fn to_coords_chars(input: String) -> List(#(#(Int, Int), String)) {
  input
  |> string.split(on: "\n")
  |> list.index_map(fn(idx, row) { #(idx, row) })
  |> list.flat_map(fn(idx_row) {
    let assert #(row_idx, row) = idx_row
    row
    |> string.to_graphemes()
    |> list.index_map(fn(col_idx, grapheme) { #(#(row_idx, col_idx), grapheme) })
  })
}

fn parse_numbers(chars_coords: List(#(#(Int, Int), String))) {
  let start_numbers: List(NumberInGrid) = []
  let current_number_type: List(#(Int, Int)) = []

  let coords_map = map.from_list(chars_coords)

  let contiguous_numbers =
    chars_coords
    |> list.filter(fn(coord_val) { list.contains(digits, coord_val.1) })
    |> list.fold(
      #(#(0, -1), current_number_type, start_numbers),
      fn(acc, coord_val) {
        let assert #(coord, _) = coord_val
        let assert #(prev_coord, current_number, total_acc) = acc
        case contiguous_coord(prev_coord, coord) {
          True -> // Number continues
          #(coord, list.append(current_number, [coord]), total_acc)
          False -> // New Number
          #(
            coord,
            [coord],
            list.prepend(total_acc, build_number(current_number, coords_map)),
          )
        }
      },
    )
  // Need to also parse the final number
  let #(_, current, final) = contiguous_numbers
  list.prepend(final, build_number(current, coords_map))
}

fn build_number(coords, coords_map) {
  let number =
    coords
    |> list.map(fn(coord) {
      let assert Ok(digit) = map.get(coords_map, coord)
      digit
    })
    |> string.join("")
    |> int.parse()
    |> result.unwrap(0)

  NumberInGrid(number: number, coords: coords)
}

fn contiguous_coord(coord1: #(Int, Int), coord2: #(Int, Int)) {
  coord1.0 == coord2.0 && coord1.1 == { coord2.1 - 1 }
}

fn adjacent_to_chars(coords, chars_map) {
  coords
  |> list.flat_map(adjacent_coords)
  |> list.any(fn(c) { has_symbol(c, chars_map) })
}

fn adjacent_coords(coord) {
  let assert #(x, y) = coord
  [
    #(x - 1, y - 1),
    #(x - 1, y),
    #(x - 1, y + 1),
    #(x, y - 1),
    #(x, y + 1),
    #(x + 1, y - 1),
    #(x + 1, y),
    #(x + 1, y + 1),
  ]
}

fn has_symbol(coord, symbols) {
  map.has_key(symbols, coord)
}
