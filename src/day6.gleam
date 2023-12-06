import simplifile
import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/regex
import gleam/result
import gleam/float

const filename = "inputs/day6"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)

  io.debug(part1(contents))
  io.debug(part2(contents))
}

pub fn part1(input: String) {
  let times_records = parse_input(input)

  times_records
  |> list.map(beating_records)
  |> int.product()
}

pub fn part2(input: String) {
  let assert [[time], [record]] =
    input
    |> string.split("\n")
    |> list.map(to_single_number)

  let a = -1.0
  let b = int.to_float(time)
  let c = int.to_float(-record)

  let assert Ok(disc) = float.square_root(b *. b -. 4.0 *. a *. c)

  let r1 =
    float.ceiling({ b -. disc } /. 2.0)
    |> float.round()
  let r2 =
    float.floor({ b +. disc } /. 2.0)
    |> float.round()

  r2 - r1 + 1
}

fn to_single_number(number: String) {
  let assert [_id, nums] = string.split(number, ":")

  let assert Ok(num) =
    nums
    |> string.replace(" ", "")
    |> int.parse()

  [num]
}

fn parse_input(input: String) {
  let assert [times, records] =
    input
    |> string.split("\n")
    |> list.map(to_list_of_ints)

  list.zip(times, records)
}

fn to_list_of_ints(numbers: String) {
  let assert [_id, nums] = string.split(numbers, ":")
  let assert Ok(re) = regex.from_string("\\s+")
  re
  |> regex.split(string.trim(nums))
  |> list.try_map(int.parse)
  |> result.unwrap([])
}

fn beating_records(time_record) {
  let assert #(time, record) = time_record

  list.range(from: 0, to: time)
  |> list.map(fn(hold) { calculate_distance(hold, time) })
  |> list.filter(fn(distance) { distance > record })
  |> list.length()
}

fn calculate_distance(hold, time) {
  hold * { time - hold }
}
