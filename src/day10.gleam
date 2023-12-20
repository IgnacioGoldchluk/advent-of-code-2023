import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/map
import gleam/int
import gleam/set

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
  io.debug(part2(contents))
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

fn calculate_loop(direction, position, grid: Grid) {
  do_loop(direction, position, grid, 0, [])
}

fn do_loop(direction, position, grid: Grid, steps, in_loop) {
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

  let new_seen = list.prepend(in_loop, next_point)

  case #(direction, next_shape) {
    #(_, Ground) -> #(0, [], direction)
    #(_, Starting) -> #(steps + 1, new_seen, direction)
    #(Up, Vertical) -> do_loop(Up, next_point, grid, steps + 1, new_seen)
    #(Up, SevenShape) -> do_loop(Left, next_point, grid, steps + 1, new_seen)
    #(Up, FShape) -> do_loop(Right, next_point, grid, steps + 1, new_seen)
    #(Down, Vertical) -> do_loop(Down, next_point, grid, steps + 1, new_seen)
    #(Down, LShape) -> do_loop(Right, next_point, grid, steps + 1, new_seen)
    #(Down, JShape) -> do_loop(Left, next_point, grid, steps + 1, new_seen)
    #(Left, Horizontal) -> do_loop(Left, next_point, grid, steps + 1, new_seen)
    #(Left, FShape) -> do_loop(Down, next_point, grid, steps + 1, new_seen)
    #(Left, LShape) -> do_loop(Up, next_point, grid, steps + 1, new_seen)
    #(Right, Horizontal) ->
      do_loop(Right, next_point, grid, steps + 1, new_seen)
    #(Right, SevenShape) -> do_loop(Down, next_point, grid, steps + 1, new_seen)
    #(Right, JShape) -> do_loop(Up, next_point, grid, steps + 1, new_seen)
    #(_, _) -> #(0, [], direction)
  }
}

fn get_result(starting_point, grid) {
  let assert Ok(result) =
    [Up, Down, Left, Right]
    |> list.map(fn(d) { #(d, calculate_loop(d, starting_point, grid)) })
    |> list.sort(fn(x1, x2) {
      let assert #(_, #(c1, _, _)) = x1
      let assert #(_, #(c2, _, _)) = x2
      int.compare(c1, c2)
    })
    |> list.last()

  result
}

fn optimal_s(starting_direction, final_direction) {
  case #(starting_direction, final_direction) {
    #(Up, Up) -> Vertical
    #(Up, Down) -> Vertical
    #(Down, Down) -> Vertical
    #(Down, Up) -> Vertical
    #(Left, Right) -> Horizontal
    #(Left, Left) -> Horizontal
    #(Right, Left) -> Horizontal
    #(Right, Right) -> Horizontal
    #(Up, Left) -> JShape
    #(Down, Left) -> SevenShape
    #(Left, Up) -> SevenShape
    #(Left, Down) -> JShape
    #(Right, Up) -> FShape
    #(Right, Down) -> LShape
    #(Down, Right) -> FShape
    #(Up, Right) -> LShape
  }
}

fn raycast(coord: Coord, points: set.Set(Coord), grid) -> Bool {
  let assert #(row, current_col) = coord

  let crosses =
    list.range(current_col, 0)
    |> list.fold(
      0,
      fn(acc, col) {
        let assert Ok(shape) = map.get(grid, #(row, col))
        case #(set.contains(points, #(row, col)), shape) {
          #(False, _) -> acc
          #(True, Vertical) -> acc + 1
          #(True, JShape) -> acc + 1
          #(True, LShape) -> acc + 1
          _ -> acc
        }
      },
    )

  int.is_odd(crosses)
}

pub fn part1(input: String) {
  let grid = to_grid(input)
  let starting_point = find_starting_point(grid)

  let assert #(_sd, #(count, _points, _fd)) = get_result(starting_point, grid)

  count / 2
}

pub fn part2(input: String) {
  let grid = to_grid(input)
  let starting_point = find_starting_point(grid)

  let result = get_result(starting_point, grid)
  let assert #(sd, #(_count, points, fd)) = result
  let grid = map.insert(grid, starting_point, optimal_s(sd, fd))

  let vertices = set.from_list(points)

  grid
  |> map.keys()
  |> list.filter(fn(k) { !set.contains(vertices, k) })
  |> list.filter(fn(coord) { raycast(coord, vertices, grid) })
  |> list.length()
}
