import simplifile
import gleam/io
import gleam/list
import gleam/map
import gleam/set
import grid_map

type Point {
  Path
  Forest
  UpSlope
  LeftSlope
  RightSlope
  DownSlope
}

type Coord =
  #(Int, Int)

type Grid =
  map.Map(Coord, Point)

type SetPath =
  set.Set(Coord)

type SetPaths =
  map.Map(Coord, SetPath)

const filename = "inputs/day23"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

fn to_point(grapheme: String) -> Point {
  case grapheme {
    "." -> Path
    "#" -> Forest
    ">" -> RightSlope
    "<" -> LeftSlope
    "v" -> DownSlope
    "^" -> UpSlope
    _ -> panic
  }
}

fn to_point_without_slopes(grapheme: String) -> Point {
  case grapheme {
    "." | "<" | ">" | "v" | "^" -> Path
    "#" -> Forest
    _ -> panic
  }
}

fn start_and_dest(grid: Grid) -> #(Coord, Coord) {
  let assert #(Ok(r), Ok(c)) = #(grid_map.max_row(grid), grid_map.max_col(grid))

  let assert Ok(start_col) =
    list.range(0, c)
    |> list.find(fn(col) {
      case map.get(grid, #(0, col)) {
        Ok(Path) -> True
        _ -> False
      }
    })

  let assert Ok(end_col) =
    list.range(0, c)
    |> list.find(fn(col) {
      case map.get(grid, #(r, col)) {
        Ok(Path) -> True
        _ -> False
      }
    })

  #(#(0, start_col), #(r, end_col))
}

fn valid_movements(pos: Coord, grid: Grid, seen: Result(SetPath, Nil)) {
  let assert Ok(seen) = seen
  let assert #(x, y) = pos
  let moves = case map.get(grid, pos) {
    Ok(UpSlope) -> [#(x - 1, y)]
    Ok(DownSlope) -> [#(x + 1, y)]
    Ok(RightSlope) -> [#(x, y + 1)]
    Ok(LeftSlope) -> [#(x, y - 1)]
    _ -> [#(x - 1, y), #(x + 1, y), #(x, y - 1), #(x, y + 1)]
  }

  moves
  |> list.filter(fn(m) {
    case map.get(grid, m) {
      Ok(Forest) -> False
      Error(_) -> False
      _ -> {
        !set.contains(seen, m)
      }
    }
  })
  |> list.map(fn(m) { #(m, seen) })
}

fn calculate_longest(
  grid: Grid,
  positions: List(Coord),
  paths: SetPaths,
  acc: Int,
) {
  case positions {
    [] -> paths
    unseen_pos -> {
      let assert #(new_positions, new_paths_sets) =
        list.flat_map(
          unseen_pos,
          fn(p) { valid_movements(p, grid, map.get(paths, p)) },
        )
        |> list.fold(
          #([], paths),
          fn(positions_paths, pos_seen) {
            let assert #(new_p, new_paths) = positions_paths
            let assert #(pos, prev) = pos_seen
            case map.get(new_paths, pos) {
              Error(_) -> #(
                [pos, ..new_p],
                map.insert(new_paths, pos, set.insert(prev, pos)),
              )
              Ok(seen) -> {
                case set.size(seen) {
                  v if v > acc -> #(new_p, new_paths)
                  v if v <= acc -> #(
                    [pos, ..new_p],
                    map.insert(new_paths, pos, set.insert(prev, pos)),
                  )
                }
              }
            }
          },
        )
      calculate_longest(grid, new_positions, new_paths_sets, acc + 1)
    }
  }
}

fn longest_path(grid: Grid) {
  let assert #(start_coords, dest_coords) = start_and_dest(grid)
  let start = [start_coords]
  let paths = map.from_list([#(start_coords, set.from_list([start_coords]))])

  let all_paths = calculate_longest(grid, start, paths, 0)

  let assert Ok(dist) = map.get(all_paths, dest_coords)
  // Subtract one because it counts the initial tile
  set.size(dist) - 1
}

pub fn part1(input: String) {
  input
  |> grid_map.parse(with: to_point)
  |> longest_path()
}

pub fn part2(input: String) {
  input
  |> grid_map.parse(with: to_point_without_slopes)
  |> longest_path()
}
