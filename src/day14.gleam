import simplifile
import gleam/io
import gleam/map
import gleam/string
import gleam/list
import gleam/pair
import gleam/int

// import gleam/order

type Shape {
  RoundedRock
  CubedRock
  EmptySpace
}

type Point =
  #(Int, Int)

type Grid =
  map.Map(Point, Shape)

const filename = "inputs/day14"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  // io.debug(part2(contents))
}

fn to_shape(shape: String) {
  case shape {
    "#" -> CubedRock
    "." -> EmptySpace
    "O" -> RoundedRock
  }
}

// fn shape_to_grapheme(shape: Shape){
//   case shape {
//     CubedRock -> "#"
//     EmptySpace -> "."
//     RoundedRock -> "O"
//   }
// }

// fn sort_coords(coord1, coord2) {
//   let assert #(x1, y1) = coord1
//   let assert #(x2, y2) = coord2
//   case int.compare(x1, x2) {
//     order.Eq -> int.compare(y1, y2)
//     other -> other
//   }
// }

// fn to_string(grid: Grid) {
//   grid
//   |> map.to_list()
//   |> list.sort(fn(c1, c2) { sort_coords(pair.first(c1), pair.first(c2))})
//   |> list.map(pair.second)
//   |> list.map(shape_to_grapheme)
//   |> string.join("")
// }

fn to_grid(input: String) -> Grid {
  input
  |> string.split("\n")
  |> list.index_map(fn(row_idx, row) {
    row
    |> string.to_graphemes()
    |> list.index_map(fn(col_idx, p) { #(#(row_idx, col_idx), to_shape(p)) })
  })
  |> list.flatten()
  |> map.from_list()
}

fn sort_row(coord1, coord2) {
  int.compare(pair.first(coord1), pair.first(coord2))
}

fn move_rocks_north(grid: Grid) -> Grid {
  grid
  |> map.to_list()
  |> list.sort(fn(c1, c2) { sort_row(pair.first(c1), pair.first(c2)) })
  |> list.fold(
    grid,
    fn(acc, k_v) {
      let assert #(#(x, y), val) = k_v
      case val {
        EmptySpace | CubedRock -> map.insert(acc, #(x, y), val)
        RoundedRock -> move_rounded_rock_north(acc, #(x, y))
      }
    },
  )
}

fn move_rounded_rock_north(grid: Grid, coords: Point) -> Grid {
  let assert #(row_idx, col_idx) = coords
  case map.get(grid, #(row_idx - 1, col_idx)) {
    Ok(EmptySpace) -> {
      let new_grid =
        grid
        |> map.insert(#(row_idx, col_idx), EmptySpace)
        |> map.insert(#(row_idx - 1, col_idx), RoundedRock)

      move_rounded_rock_north(new_grid, #(row_idx - 1, col_idx))
    }
    _ -> grid
  }
}

fn calculate_load(grid: Grid) -> Int {
  let assert Ok(length) =
    grid
    |> map.keys()
    |> list.map(pair.first)
    |> list.reduce(int.max)

  grid
  |> map.filter(fn(_k, v) { v == RoundedRock })
  |> map.keys()
  |> list.map(pair.first)
  |> list.map(fn(row_idx) { length + 1 - row_idx })
  |> int.sum()
}

pub fn part1(input: String) {
  input
  |> to_grid()
  |> move_rocks_north()
  |> calculate_load()
}
// pub fn part2(input: String) {
//   todo
// }
