import simplifile
import gleam/io
import gleam/list
import gleam/int
import gleam/map
import gleam/pair
import gleam/set
import heap_queue
import grid_map

const filename = "inputs/day17"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

fn parse_heat(heat: String) {
  let assert Ok(h) = int.parse(heat)
  h
}

fn destination(grid) {
  let assert Ok(max_row) =
    grid
    |> map.keys()
    |> list.map(pair.first)
    |> list.reduce(int.max)
  let assert Ok(max_col) =
    grid
    |> map.keys()
    |> list.map(pair.second)
    |> list.reduce(int.max)

  #(max_row, max_col)
}

fn update_queue_2(h, x, y, dx, dy, n, grid, queue) {
  // Must go straight at least 4 times
  let keep_straight = case #(dx, dy, n) {
    #(dx, dy, n) if n < 10 && #(dx, dy) != #(0, 0) -> {
      let assert #(new_x, new_y) = #(x + dx, y + dy)
      case map.get(grid, #(new_x, new_y)) {
        Error(_) -> []
        Ok(heat) -> [#(heat + h, #(new_x, new_y, dx, dy, n + 1))]
      }
    }
    _ -> []
  }

  [#(0, 1), #(0, -1), #(1, 0), #(-1, 0)]
  |> list.filter(fn(dir) {
    dir != #(dx, dy) && dir != #(-dx, -dy) && { n >= 4 || #(dx, dy) == #(0, 0) }
  })
  |> list.filter(fn(dir) {
    let assert #(new_dx, new_dy) = dir
    map.has_key(grid, #(x + new_dx, y + new_dy))
  })
  |> list.map(fn(dir) {
    let assert #(new_dx, new_dy) = dir
    let assert #(new_x, new_y) = #(x + new_dx, y + new_dy)
    let assert Ok(heat) = map.get(grid, #(new_x, new_y))
    #(heat + h, #(new_x, new_y, new_dx, new_dy, 1))
  })
  |> list.append(keep_straight)
  |> list.fold(
    queue,
    fn(q, point) {
      let assert #(heat, rest) = point
      heap_queue.push(q, heat, rest)
    },
  )
}

fn update_queue(h, x, y, dx, dy, n, grid, queue) {
  let keep_straight = case #(dx, dy, n) {
    #(dx, dy, n) if n < 3 && #(dx, dy) != #(0, 0) -> {
      // Go straight if not out of bounds
      let assert #(new_x, new_y) = #(x + dx, y + dy)
      case map.get(grid, #(new_x, new_y)) {
        Error(_) -> []
        Ok(heat) -> [#(heat + h, #(new_x, new_y, dx, dy, n + 1))]
      }
    }
    _ -> []
  }

  // All possible directions, ignore straight line (covered above)
  // and also we cannot go backwards (-dx, -dy)
  [#(0, 1), #(0, -1), #(1, 0), #(-1, 0)]
  |> list.filter(fn(dir) { dir != #(dx, dy) && dir != #(-dx, -dy) })
  |> list.filter(fn(dir) {
    let assert #(new_dx, new_dy) = dir
    map.has_key(grid, #(x + new_dx, y + new_dy))
  })
  |> list.map(fn(dir) {
    let assert #(new_dx, new_dy) = dir
    let assert #(new_x, new_y) = #(x + new_dx, y + new_dy)
    let assert Ok(heat) = map.get(grid, #(new_x, new_y))
    #(heat + h, #(new_x, new_y, new_dx, new_dy, 1))
  })
  |> list.append(keep_straight)
  |> list.fold(
    queue,
    fn(q, point) {
      let assert #(heat, rest) = point
      heap_queue.push(q, heat, rest)
    },
  )
}

fn traverse_2(grid, dest, queue, seen) {
  let assert Ok(#(#(heat, pos_dir), q)) = heap_queue.pop(queue)
  let assert #(x, y, dx, dy, n) = pos_dir
  let in_set = set.contains(seen, #(x, y, dx, dy, n))

  case #(x, y) {
    pos if pos == dest && n >= 4 -> heat
    _pos if in_set -> traverse_2(grid, dest, q, seen)
    _ -> {
      let new_queue = update_queue_2(heat, x, y, dx, dy, n, grid, queue)
      traverse_2(grid, dest, new_queue, set.insert(seen, pos_dir))
    }
  }
}

fn traverse(grid, dest, queue, seen) {
  let assert Ok(#(#(heat, pos_dir), q)) = heap_queue.pop(queue)
  let assert #(x, y, dx, dy, n) = pos_dir
  let in_set = set.contains(seen, #(x, y, dx, dy, n))

  case #(x, y) {
    pos if pos == dest -> heat
    _pos if in_set -> traverse(grid, dest, q, seen)
    _ -> {
      let new_queue = update_queue(heat, x, y, dx, dy, n, grid, queue)
      traverse(grid, dest, new_queue, set.insert(seen, pos_dir))
    }
  }
}

fn shortest_path(grid, dest) {
  let start = #(0, 0, 0, 0, 0)
  traverse(grid, dest, heap_queue.new(0, start), set.new())
}

fn shortest_path_2(grid, dest) {
  let start = #(0, 0, 0, 0, 0)
  traverse_2(grid, dest, heap_queue.new(0, start), set.new())
}

pub fn part1(input: String) {
  let grid = grid_map.parse(input, parse_heat)

  shortest_path(grid, destination(grid))
}

pub fn part2(input: String) {
  let grid = grid_map.parse(input, parse_heat)

  shortest_path_2(grid, destination(grid))
}
