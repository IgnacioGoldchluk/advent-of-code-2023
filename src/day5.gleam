import gleam/string
import gleam/io
import gleam/list
import gleam/int
import simplifile

const filename = "inputs/day5"

type SeedsRange {
  SeedsRange(start: Int, end: Int)
}

type Mapping {
  Mapping(source: Int, destination: Int, range: Int)
}

type MappingStep {
  MappingStep(source: String, destination: String, mappings: List(Mapping))
}

pub fn solve() {
  let assert Ok(contents) = simplifile.read(filename)

  io.debug(part1(contents))
  io.debug(part2(contents))
}

pub fn part1(input: String) {
  let assert [seeds, ..mappings_steps] = string.split(input, "\n\n")
  let assert Ok(seeds) = seeds_numbers(seeds)

  let mappings_steps = list.map(mappings_steps, to_mapping_step)

  let assert Ok(min) =
    seeds
    |> list.map(fn(seed) { to_location_value(seed, mappings_steps) })
    |> list.reduce(int.min)

  min
}

pub fn part2(input: String) {
  let assert [seeds, ..mapping_steps] = string.split(input, "\n\n")
  let seeds = seeds_ranges(seeds)

  let mapping_steps = list.map(mapping_steps, to_mapping_step)

  let assert Ok(min_val) =
    seeds
    |> list.map(io.debug)
    |> list.flat_map(fn(seed) { to_location_ranges(seed, mapping_steps) })
    |> list.map(fn(seed_range) { seed_range.start })
    |> list.reduce(int.min)

  min_val
}

fn seeds_ranges(seeds) {
  let assert Ok(int_seeds) = seeds_numbers(seeds)
  int_seeds
  |> list.sized_chunk(2)
  |> list.map(fn(start_range) {
    let assert [start, range] = start_range
    SeedsRange(start: start, end: start + range)
  })
}

fn seeds_numbers(seeds: String) {
  seeds
  |> string.replace("seeds: ", "")
  |> string.split(" ")
  |> list.try_map(int.parse)
}

fn to_mapping_step(mapping: String) {
  let assert [maps, ..ranges] = string.split(mapping, "\n")
  let assert [src, "to", dest] =
    string.replace(maps, " map:", "")
    |> string.split("-")

  MappingStep(
    source: src,
    destination: dest,
    mappings: list.map(ranges, to_mapping),
  )
}

fn to_mapping(range: String) {
  let assert Ok([dest, src, steps]) =
    range
    |> string.split(" ")
    |> list.try_map(int.parse)

  Mapping(source: src, destination: dest, range: steps)
}

fn to_location_value(seed: Int, mapping_steps: List(MappingStep)) {
  list.fold(
    mapping_steps,
    seed,
    fn(val, mapping_step) {
      let match =
        mapping_step.mappings
        |> list.filter(fn(mapping) {
          val >= mapping.source && val <= mapping.source + mapping.range
        })
        |> list.first()

      case match {
        Error(_) -> val
        Ok(mapping) -> val - mapping.source + mapping.destination
      }
    },
  )
}

fn to_location_ranges(seed: SeedsRange, mapping_steps: List(MappingStep)) {
  list.fold(mapping_steps, [[seed], []], fn(acc, mapping_step) { todo })
}
