import gleam/int
import gleam/string
import simplifile

pub fn new_day(day: Int) {
  let assert Ok(_) = create_input(day)
  let assert Ok(_) = create_test(day)
  let assert Ok(_) = create_day_file(day)
}

fn create_day_file(day: Int) {
  let day_str = int.to_string(day)

  let filename = "src/day" <> day_str <> ".gleam"
  let contents =
    "import simplifile
import gleam/io
import gleam/string
import gleam/list

const filename = \"inputs/day{num}\"
pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

pub fn part1(input: String) {
  todo
}

pub fn part2(input: String) {
  todo
}"

  simplifile.write(
    to: filename,
    contents: string.replace(contents, "{num}", day_str),
  )
}

fn create_test(day: Int) {
  let filename = "test/day" <> int.to_string(day) <> "_test.gleam"

  let contents =
    "import day{num}
import gleeunit/should
  
pub fn day{num}_part1_test() {
  let test_input = \"\"

  day{num}.part1(test_input)
  |> should.equal(123)
}
pub fn day{num}_part2_test() {
  let test_input = \"\"
  
  day{num}.part2(test_input)
  |> should.equal(123)
}"
  simplifile.write(
    to: filename,
    contents: string.replace(contents, "{num}", int.to_string(day)),
  )
}

fn create_input(day: Int) {
  let filename = "inputs/day" <> int.to_string(day)
  let contents = ""

  simplifile.write(to: filename, contents: contents)
}
