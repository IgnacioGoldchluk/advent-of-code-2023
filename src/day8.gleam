import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/map
import gleam/iterator

const filename = "inputs/day8"

type Node {
  Node(left: String, right: String)
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)
  io.debug(part1(contents))
  // io.debug(part2(contents))
}

pub fn part1(input: String) {
  let assert [instructions, nodes] = string.split(input, "\n\n")
  let instructions =
    string.to_graphemes(instructions)
    |> iterator.from_list()
    |> iterator.cycle()

  let nodes = to_nodes(nodes)

  let assert #(c, _) = steps_required(nodes, instructions, "AAA", "ZZZ")
  c
}

fn steps_required(nodes, instructions, start, end) {
  instructions
  |> iterator.fold_until(
    #(0, start),
    fn(acc, new_instruction) {
      let assert #(count, current) = acc
      let assert Ok(Node(left: l, right: r)) = map.get(nodes, current)
      let new = case new_instruction {
        "L" -> l
        "R" -> r
      }

      case new {
        x if x == end -> list.Stop(#(count + 1, new))
        new -> list.Continue(#(count + 1, new))
      }
    },
  )
}

fn to_nodes(nodes: String) {
  nodes
  |> string.split("\n")
  |> list.fold(
    map.new(),
    fn(acc, new_node) {
      let assert [node, left, right] = get_node(new_node)
      map.insert(acc, node, Node(left: left, right: right))
    },
  )
}

fn get_node(node) {
  let assert [node_name, l_r] = string.split(node, " = ")
  let assert [l, r] =
    l_r
    |> string.replace("(", "")
    |> string.replace(")", "")
    |> string.split(", ")

  [node_name, l, r]
}
// pub fn part2(input: String) {
//   todo
// }
