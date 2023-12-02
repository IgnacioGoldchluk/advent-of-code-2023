import gleam/string
import gleam/int
import gleam/list
import gleam/io
import gleam/map
import gleam/result
import gleam/option
import simplifile
import gleam/regex

const filename = "inputs/day2"

type Colors {
  Colors(r: Int, g: Int, b: Int)
}

type Game {
  Game(game_id: Int, colors: Colors)
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
  |> list.filter(fn(g) { g.colors.r <= 12 && g.colors.g <= 13 && g.colors.b <= 14})
  |> list.map(fn(game) { game.game_id })
  |> int.sum()
}

fn parse_game(input: String) {
  let assert ["Game " <> game_id, sets] = string.split(input, on: ": ")
  let assert Ok(game_id) = int.parse(game_id)
  Game(game_id: game_id, colors: max_colors(sets))
}

fn max_colors(sets: String) {
  let colors = list.map(["green", "red", "blue"], fn(color) {
  let assert Ok(color_re) = regex.from_string("(\\d+) "<>color)
  #(color, max_color(regex.scan(color_re, sets)))
  })
  |> map.from_list()

  Colors(
    r: map.get(colors, "red") |> result.unwrap(0),
    g: map.get(colors, "green") |> result.unwrap(0),
    b: map.get(colors, "blue") |> result.unwrap(0)
  )
}

fn max_color(matches: List(regex.Match)) -> Int {
  matches
  |> list.flat_map(fn(match) { match.submatches })
  |> list.fold(0, fn (curr_max, submatch) {
    let assert Ok(submatch_int) = int.parse(option.unwrap(submatch, "0"))
    int.max(curr_max, submatch_int)
  })
}

pub fn part2(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(parse_game)
  |> list.map(fn(g) { g.colors.r * g.colors.g * g.colors.b })
  |> int.sum()
}
