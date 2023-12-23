import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/int
import gleam/map
import gleam/option
import gleam/pair

type Label {
  Subtract(hash: Int, label: String)
  Insert(hash: Int, label: String, value: Int)
}

type Boxes =
  map.Map(Int, List(#(String, Int)))

const filename = "inputs/day15"

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  io.debug(part2(contents))
}

fn to_codes(input: String) -> List(Int) {
  input
  |> string.replace("\n", "")
  |> string.split(",")
  |> list.map(hash_value)
}

fn hash_value(code: String) -> Int {
  code
  |> string.to_utf_codepoints()
  |> list.map(string.utf_codepoint_to_int)
  |> list.fold(
    0,
    fn(acc, char) {
      let assert Ok(new) =
        acc
        |> int.add(char)
        |> int.multiply(17)
        |> int.modulo(256)

      new
    },
  )
}

fn to_label_codes(input: String) -> List(Label) {
  input
  |> string.replace("\n", "")
  |> string.split(",")
  |> list.map(to_label_code)
}

fn to_label_code(code: String) -> Label {
  case string.split(code, "=") {
    [l] -> {
      let label = string.replace(l, "-", "")
      Subtract(hash: hash_value(label), label: label)
    }
    [l, v] -> {
      let assert Ok(value) = int.parse(v)
      Insert(hash: hash_value(l), label: l, value: value)
    }
  }
}

fn focusing_power(boxes: Boxes) -> Int {
  boxes
  |> map.map_values(fn(_k, v) { list.reverse(v) })
  |> map.to_list()
  |> list.flat_map(fn(box_no_lenses) {
    let assert #(box_no, lenses) = box_no_lenses

    lenses
    |> list.index_map(fn(idx, lens) {
      let assert #(_label, focal_length) = lens
      { box_no + 1 } * { focal_length } * { idx + 1 }
    })
  })
  |> int.sum()
}

fn delete_box(box: option.Option(List(#(String, Int))), label: String) {
  box
  |> option.unwrap([])
  |> list.filter(fn(l) { pair.first(l) != label })
}

fn insert_box(box, label, value) {
  let assert option.Some(box) = box
  let exists = list.find(box, fn(l) { pair.first(l) == label })

  case exists {
    Error(Nil) -> list.prepend(box, #(label, value))
    _ -> {
      box
      |> list.map(fn(l) {
        case pair.first(l) {
          x if x == label -> #(label, value)
          _ -> l
        }
      })
    }
  }
}

fn update_boxes(boxes: Boxes, label: Label) {
  case label {
    Subtract(hash: h, label: l) -> {
      map.update(boxes, h, fn(b) { delete_box(b, l) })
    }
    Insert(hash: h, label: l, value: v) -> {
      map.update(boxes, h, fn(b) { insert_box(b, l, v) })
    }
  }
}

pub fn part1(input: String) {
  input
  |> to_codes()
  |> int.sum()
}

pub fn part2(input: String) {
  let boxes =
    list.range(0, 255)
    |> list.map(fn(b) { #(b, []) })
    |> map.from_list()

  input
  |> to_label_codes()
  |> list.fold(boxes, update_boxes)
  |> focusing_power()
}
