import simplifile
import gleam/io
import gleam/list
import gleam/map
import gleam/int
import gleam/pair
import grid_map

const filename = "inputs/day11"

type Point {
  Empty
  Galaxy
}

type Coord =
  #(Int, Int)

type Space =
  map.Map(Coord, Point)

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

fn to_point(grapheme: String) {
  case grapheme {
    "#" -> Galaxy
    "." -> Empty
    _ -> panic
  }
}

fn manhattan(c1: Coord, c2: Coord, exp_rows, exp_cols, expansion_size) {
  let assert #(x1, y1) = c1
  let assert #(x2, y2) = c2

  let assert [x1, x2] = list.sort([x1, x2], int.compare)
  let assert [y1, y2] = list.sort([y1, y2], int.compare)

  let extra_row =
    list.filter(exp_rows, fn(r) { r > x1 && r < x2 })
    |> list.length()
    |> int.multiply(int.max(expansion_size - 1, 1))

  let extra_col =
    list.filter(exp_cols, fn(c) { c > y1 && c < y2 })
    |> list.length()
    |> int.multiply(int.max(expansion_size - 1, 1))

  int.absolute_value(x1 - x2) + int.absolute_value(y1 - y2) + extra_row + extra_col
}

fn max_row_and_col(grid) {
  let keys = map.keys(grid)
  let assert Ok(max_row) =
    list.map(keys, pair.first)
    |> list.reduce(int.max)

  let assert Ok(max_col) =
    list.map(keys, pair.second)
    |> list.reduce(int.max)

  #(max_row, max_col)
}

fn empty_rows_and_cols(space: Space) {
  let assert #(max_row, max_col) = max_row_and_col(space)

  let empty_rows =
    list.range(0, max_row)
    |> list.filter(fn(row_idx) {
      list.range(0, max_col)
      |> list.map(fn(col_idx) { map.get(space, #(row_idx, col_idx)) })
      |> list.all(is_empty)
    })

  let empty_cols =
    list.range(0, max_col)
    |> list.filter(fn(col_idx) {
      list.range(0, max_row)
      |> list.map(fn(row_idx) { map.get(space, #(row_idx, col_idx)) })
      |> list.all(is_empty)
    })
  #(empty_rows, empty_cols)
}

fn is_empty(p) {
  case p {
    Ok(Empty) -> True
    _ -> False
  }
}

fn galaxies(space: Space) -> List(Coord) {
  space
  |> map.filter(fn(_k, v) { v == Galaxy })
  |> map.keys()
}

pub fn solution(input: String, empty_galaxies_width) {
  let space = grid_map.parse(input, to_point)
  let assert #(empty_rows, empty_cols) = empty_rows_and_cols(space)

  space
  |> galaxies()
  |> list.combination_pairs()
  |> list.map(fn(g1_g2) {
    let assert #(g1, g2) = g1_g2
    manhattan(g1, g2, empty_rows, empty_cols, empty_galaxies_width)
  })
  |> int.sum()
}

pub fn part1(input: String) {
  solution(input, 1)
}

pub fn part2(input: String) {
  solution(input, 1_000_000)
}
