import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/map
import gleam/set
import gleam/int
import gleam/pair

type Direction {
  Up
  Down
  Left
  Right
}

type Tile {
  VerticalSplitter
  HorizontalSplitter
  SlashMirror
  BackslashMirror
  Empty
}

type Coord =
  #(Int, Int)

type Grid =
  map.Map(Coord, Tile)

type Beam =
  #(Coord, Direction)

const filename = "inputs/day16"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

fn to_tile(grapheme) {
  case grapheme {
    "\\" -> BackslashMirror
    "/" -> SlashMirror
    "." -> Empty
    "|" -> VerticalSplitter
    "-" -> HorizontalSplitter
  }
}

fn to_grid(input: String) -> Grid {
  input
  |> string.split("\n")
  |> list.index_map(fn(row_idx, row) {
    row
    |> string.to_graphemes()
    |> list.index_map(fn(col_idx, p) { #(#(row_idx, col_idx), to_tile(p)) })
  })
  |> list.flatten()
  |> map.from_list()
}

fn next_beams(beam: Beam, tile: Tile) {
  let assert #(#(x, y), dir) = beam
  case #(dir, tile) {
    #(Up, VerticalSplitter) | #(Up, Empty) -> [#(#(x - 1, y), Up)]
    #(Down, VerticalSplitter) | #(Down, Empty) -> [#(#(x + 1, y), Down)]
    #(Left, Empty) | #(Left, HorizontalSplitter) -> [#(#(x, y - 1), Left)]
    #(Right, Empty) | #(Right, HorizontalSplitter) -> [#(#(x, y + 1), Right)]
    #(Up, SlashMirror) | #(Down, BackslashMirror) -> [#(#(x, y + 1), Right)]
    #(Up, BackslashMirror) | #(Down, SlashMirror) -> [#(#(x, y - 1), Left)]
    #(Up, HorizontalSplitter) | #(Down, HorizontalSplitter) -> [
      #(#(x, y - 1), Left),
      #(#(x, y + 1), Right),
    ]
    #(Right, VerticalSplitter) | #(Left, VerticalSplitter) -> [
      #(#(x - 1, y), Up),
      #(#(x + 1, y), Down),
    ]
    #(Right, SlashMirror) | #(Left, BackslashMirror) -> [#(#(x - 1, y), Up)]
    #(Right, BackslashMirror) | #(Left, SlashMirror) -> [#(#(x + 1, y), Down)]
  }
}

fn beam_step(grid_beams_seen, beam: Beam) {
  let assert #(grid, beams, seen) = grid_beams_seen
  let assert #(pos, _) = beam
  case set.contains(seen, beam) || !map.has_key(grid, pos) {
    True -> #(grid, beams, seen)
    False -> {
      let new_seen = set.insert(seen, beam)
      let assert Ok(tile) = map.get(grid, pos)
      let new_beams = list.append(beams, next_beams(beam, tile))
      #(grid, new_beams, new_seen)
    }
  }
}

fn fill_grid(grid, beams) {
  do_fill_grid(grid, beams, set.new())
}

fn do_fill_grid(grid: Grid, beams: List(Beam), seen: set.Set(Beam)) {
  case beams {
    [] -> seen
    beams_list -> {
      let assert #(new_grid, new_beams, new_seen) =
        list.fold(beams_list, #(grid, [], seen), beam_step)
      do_fill_grid(new_grid, new_beams, new_seen)
    }
  }
}

fn count_energized(grid, starting_beam) {
  fill_grid(grid, [starting_beam])
  |> set.to_list()
  |> list.map(fn(pos_dir) { pair.first(pos_dir) })
  |> set.from_list()
  |> set.size()
}

pub fn part1(input: String) {
  count_energized(to_grid(input), #(#(0, 0), Right))
}

// For part 2 one should actually do as follows:
// 1. Create an empty hashmap of (beam, energized)
// 2. Iterate over the valid positions
// 3. For each beam step, update the hashmap as:
//    if map.has_key(hashmap, beam) {
//       return map.get(hashmap, beam)
//}
//    beams = next_beams(beam)
//    hashmap[beam] = 1 + [energized_value(hashmap, b) for b in beam]
//    hashmap must be shared across every call of energized_value
fn max_row_col(grid) {
  let coords = map.keys(grid)
  let assert Ok(max_row) =
    coords
    |> list.map(pair.first)
    |> list.reduce(int.max)
  let assert Ok(max_col) =
    coords
    |> list.map(pair.second)
    |> list.reduce(int.max)

  #(max_row, max_col)
}

fn edges(grid) {
  let #(m_r, m_c) = max_row_col(grid)

  let top_row = list.map(list.range(0, m_c), fn(c) { #(0, c) })
  let bottom_row = list.map(list.range(0, m_c), fn(c) { #(m_r, c) })
  let first_col = list.map(list.range(0, m_r), fn(r) { #(r, 0) })
  let last_col = list.map(list.range(0, m_r), fn(r) { #(r, m_c) })

  list.concat([top_row, bottom_row, first_col, last_col])
}

pub fn part2(input: String) {
  let grid = to_grid(input)
  let directions = [Up, Down, Left, Right]

  let assert Ok(max) =
    edges(grid)
    |> list.flat_map(fn(edge) { list.map(directions, fn(d) { #(edge, d) }) })
    |> list.map(fn(beam) { count_energized(grid, beam) })
    |> list.reduce(int.max)

  max
}
