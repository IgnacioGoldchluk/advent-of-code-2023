import glint.{type CommandInput}
import glint/flag
import day0
import day1
import day2
import day3
import day4
import day5
import day6
import day7
import day8
import day9
import day10
import day11
import day13
import day14
import day15
import day16
import gleam/erlang.{start_arguments}
import create_template

const day_flag_name = "day"

const new_day_flag_name = "new-day"

fn day_flag() -> flag.FlagBuilder(Int) {
  flag.int()
  |> flag.default(-1)
  |> flag.description("The day to run")
}

fn new_day_flag() -> flag.FlagBuilder(Int) {
  flag.int()
  |> flag.default(-1)
  |> flag.description("Template for a new day")
}

fn advent_of_code(input: CommandInput) -> Nil {
  let assert Ok(day) = flag.get_int(from: input.flags, for: day_flag_name)
  let assert Ok(new_day) =
    flag.get_int(from: input.flags, for: new_day_flag_name)

  case new_day {
    x if x <= 25 && x >= 1 -> create_template.new_day(new_day)
    _ -> Ok(Nil)
  }

  let _ = case day {
    -1 -> -1
    0 -> day0.day0()
    1 -> day1.solve()
    2 -> day2.solve()
    3 -> day3.solve()
    4 -> day4.solve()
    5 -> day5.solve()
    6 -> day6.solve()
    7 -> day7.solve()
    8 -> day8.solve()
    9 -> day9.solve()
    10 -> day10.solve()
    11 -> day11.solve()
    13 -> day13.solve()
    14 -> day14.solve()
    15 -> day15.solve()
    16 -> day16.solve()
    _ -> panic
  }
  Nil
}

pub fn main() {
  glint.new()
  |> glint.with_name("Advent of code 2023")
  |> glint.with_pretty_help(glint.default_pretty_help())
  |> glint.add(
    // Command at the root
    at: [],
    do: glint.command(advent_of_code)
    |> glint.flag(day_flag_name, day_flag())
    |> glint.flag(new_day_flag_name, new_day_flag())
    |> glint.description("Runs AoC with the specified day"),
  )
  |> glint.run(start_arguments())
}
