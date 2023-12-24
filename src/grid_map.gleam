import gleam/map
import gleam/list
import gleam/string
import gleam/int
import gleam/pair

pub fn parse(
  input: String,
  with mapping: fn(String) -> a,
) -> map.Map(#(Int, Int), a) {
  input
  |> string.split("\n")
  |> list.index_map(fn(row_idx, row) {
    row
    |> string.to_graphemes()
    |> list.index_map(fn(col_idx, value) {
      #(#(row_idx, col_idx), mapping(value))
    })
  })
  |> list.flatten()
  |> map.from_list()
}

pub fn max_col(grid) {
  grid
  |> map.keys()
  |> list.map(pair.second)
  |> list.reduce(int.max)
}

pub fn max_row(grid) {
  grid
  |> map.keys()
  |> list.map(pair.first)
  |> list.reduce(int.max)
}
