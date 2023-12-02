import gleam/string
import gleam/int
import gleam/list
import gleam/io
import gleam/map
import gleam/result
import simplifile

const filename = "inputs/day2"

pub type GameSet = map.Map(String, Int)

pub type Game {
  Game(game_id: Int, game_sets: List(GameSet))
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

pub fn part1(input: String) {
    input
    |> string.split(on: "\n")
    |> list.map(parse_game)
    |> list.filter(is_game_possible)
    |> list.map(fn(game) { game.game_id})
    |> int.sum()
}

pub fn part2(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(parse_game)
  |> list.map(power_of_min_cubes)
  |> int.sum()
}

fn parse_game(game: String) -> Game {
  let assert ["Game " <> game_id, sets] = string.split(game, on: ": ")
  let assert Ok(game_id) = int.parse(game_id)
  Game(game_id: game_id, game_sets: parse_sets(sets))
}

fn parse_sets(sets: String) -> List(GameSet) {
  sets
  |> string.split(on: ";")
  |> list.map(parse_set)
}

fn parse_set(set: String) -> GameSet {
  set
  |> string.trim()
  |> string.split(on: ",")
  |> list.map(fn(colors_numbers) {
    let assert [number, color] = 
    colors_numbers
    |> string.trim()
    |> string.split(" ")

    let assert Ok(number) = int.parse(number)
    #(color, number)
  })
  |> map.from_list()
}

fn is_game_possible(game: Game) -> Bool {
  let possible: GameSet = map.from_list([#("red", 12), #("green", 13), #("blue", 14)])
  list.all(game.game_sets, fn(game_set) {is_set_possible(game_set, possible)})
}

fn is_set_possible(game_set: GameSet, possible: GameSet) {
  list.all(map.keys(possible), fn(key) {
    let assert Ok(possible_val) = map.get(possible, key)

    case map.get(game_set, key) {
      Ok(x) if x > possible_val -> False
      _ -> True
    }
  })
}

fn power_of_min_cubes(game: Game) -> Int {
  let max_cubes = list.fold(
    over: game.game_sets,
    from: map.from_list([#("red", 0), #("green", 0), #("blue", 0)]),
    with: update_max_colors)
  
  max_cubes |> map.values() |> int.product()
}

fn update_max_colors(current: GameSet, new: GameSet) -> GameSet {
  list.fold(over: map.keys(new), from: current, with: fn(acc, key) {
    let assert Ok(val) = map.get(new, key)
    let existing = map.get(acc, key) |> result.unwrap(0)
    map.insert(acc, key, int.max(val, existing))
  })
}