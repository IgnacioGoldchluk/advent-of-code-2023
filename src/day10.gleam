import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/map
import gleam/int
import gleam/result

const filename = "inputs/day10"

type Coord =
  #(Int, Int)

type Point {
  Vertical
  Horizontal
  LShape
  JShape
  SevenShape
  FShape
  Ground
  Starting
}

type Grid =
  map.Map(Coord, Point)

type Direction {
  Up
  Down
  Left
  Right
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  // io.debug(part2(contents))
}

fn to_point(grapheme: String) {
  case grapheme {
    "." -> Ground
    "|" -> Vertical
    "-" -> Horizontal
    "L" -> LShape
    "J" -> JShape
    "7" -> SevenShape
    "F" -> FShape
    "S" -> Starting
  }
}

fn to_grid(input: String) -> Grid {
  input
  |> string.split("\n")
  |> list.index_map(fn(row_idx, row) {
    row
    |> string.to_graphemes()
    |> list.index_map(fn(col_idx, p) { #(#(row_idx, col_idx), to_point(p)) })
  })
  |> list.flatten()
  |> map.from_list()
}

fn find_starting_point(grid: Grid) -> Coord {
  let assert Ok(#(starting_coords, Starting)) =
    grid
    |> map.filter(fn(_k, v) { v == Starting })
    |> map.to_list()
    |> list.first()

  starting_coords
}

fn calculate_loop(direction, position, grid: Grid) -> Int {
  do_loop(direction, position, grid, 0)
}

fn do_loop(direction, position, grid: Grid, steps) -> Int {
  let assert #(x, y) = position
  let next_point = case direction {
    Up -> #(x - 1, y)
    Down -> #(x + 1, y)
    Left -> #(x, y - 1)
    Right -> #(x, y + 1)
  }

  let next_shape = case map.get(grid, next_point) {
    Error(_) -> Ground
    Ok(shape) -> shape
  }

  case #(direction, next_shape) {
    #(_, Ground) -> 0
    #(_, Starting) -> steps + 1
    #(Up, Vertical) -> do_loop(Up, next_point, grid, steps + 1)
    #(Up, SevenShape) -> do_loop(Left, next_point, grid, steps + 1)
    #(Up, FShape) -> do_loop(Right, next_point, grid, steps + 1)
    #(Down, Vertical) -> do_loop(Down, next_point, grid, steps + 1)
    #(Down, LShape) -> do_loop(Right, next_point, grid, steps + 1)
    #(Down, JShape) -> do_loop(Left, next_point, grid, steps + 1)
    #(Left, Horizontal) -> do_loop(Left, next_point, grid, steps + 1)
    #(Left, FShape) -> do_loop(Down, next_point, grid, steps + 1)
    #(Left, LShape) -> do_loop(Up, next_point, grid, steps + 1)
    #(Right, Horizontal) -> do_loop(Right, next_point, grid, steps + 1)
    #(Right, SevenShape) -> do_loop(Down, next_point, grid, steps + 1)
    #(Right, JShape) -> do_loop(Up, next_point, grid, steps + 1)
    #(_, _) -> 0
  }
}

pub fn part1(input: String) {
  let grid =
    input
    |> to_grid()

  let starting_point = find_starting_point(grid)

  [Up, Down, Left, Right]
  |> list.map(fn(direction) { calculate_loop(direction, starting_point, grid) })
  |> list.reduce(int.max)
  |> result.unwrap(0)
  |> int.divide(2)
  |> result.unwrap(0)
}

// pub fn part2(input: String) {
//   todo
// }
