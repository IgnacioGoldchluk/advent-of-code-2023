import glint.{type CommandInput}
import glint/flag
import day0
import gleam/erlang.{start_arguments}

const day_flag_name = "day"

fn day_flag() -> flag.FlagBuilder(Int) {
  flag.int()
  |> flag.default(0)
  |> flag.description("The day to run")
}

fn advent_of_code(input: CommandInput) -> Nil {
  let assert Ok(day) = flag.get_int(from: input.flags, for: day_flag_name)

  case day {
    0 -> day0.day0()
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
    |> glint.description("Runs AoC with the specified day"),
  )
  |> glint.run(start_arguments())
}
