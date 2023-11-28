import gleam/io
import gleam/map
import gleam/erlang.{start_arguments}
import glint.{CommandInput}
import glint/flag
import day0

pub fn main() {
  let command = fn(input: CommandInput) {
    let assert Ok(flag.I(day)) = map.get(input.flags, "day")
    case day {
      0 -> day0.day0()
      _ -> todo
    }
  }

  glint.new()
  |> glint.add_command([], command, [flag.int("day", 0)])
  |> glint.run(start_arguments())
}
