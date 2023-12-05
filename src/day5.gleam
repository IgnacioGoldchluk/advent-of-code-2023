import gleam/string
import gleam/io
import gleam/list
import gleam/int
import gleam/result
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

  seeds
  |> list.map(fn(seed) { to_location_value(seed, mappings_steps) })
  |> list.reduce(int.min)
  |> result.unwrap(0)
}

pub fn part2(input: String) {
  let assert [seeds, ..mapping_steps] = string.split(input, "\n\n")
  let seeds = seeds_ranges(seeds)

  let mapping_steps = list.map(mapping_steps, to_mapping_step)

  seeds
  |> list.flat_map(fn(seed) { to_location_ranges(seed, mapping_steps) })
  |> list.map(fn(seed_range) { seed_range.start })
  |> list.reduce(int.min)
  |> result.unwrap(0)
}

fn seeds_ranges(seeds) {
  let assert Ok(int_seeds) = seeds_numbers(seeds)
  int_seeds
  |> list.sized_chunk(2)
  |> list.map(fn(start_range) {
    let assert [start, range] = start_range
    SeedsRange(start: start, end: start + range - 1)
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

fn join_lists(list1, list2) {
  let assert [s1, e1] = list1
  let assert [s2, e2] = list2
  [list.append(s1, s2), list.append(e1, e2)]
}

fn apply_mapping_to_seeds(seeds: List(List(SeedsRange)), mapping: Mapping) {
  let assert [unparsed, parsed] = seeds
  let assert [new_unparsed, new_parsed] =
    unparsed
    |> list.map(fn(seed) { extract_ranges(seed, mapping) })
    |> list.fold([[], []], join_lists)

  [new_unparsed, list.append(parsed, new_parsed)]
}

fn apply_mapping_step(seeds: List(SeedsRange), mapping_step: MappingStep) {
  list.fold(mapping_step.mappings, [seeds, []], apply_mapping_to_seeds)
  |> list.concat()
}

fn to_location_ranges(seed: SeedsRange, mapping_steps: List(MappingStep)) {
  list.fold(mapping_steps, [seed], apply_mapping_step)
}

fn extract_ranges(range: SeedsRange, mapping: Mapping) {
  let start = mapping.source
  let end = mapping.source + mapping.range - 1

  case range {
    SeedsRange(start: s, end: e) if s >= start && e <= end ->
      fully_contained(range, mapping)
    SeedsRange(start: s, end: e) if e < start || s > end ->
      fully_outside(range, mapping)
    SeedsRange(start: s, end: e) if s < start && e > end ->
      fully_contains(range, mapping)
    SeedsRange(start: s, end: e) if s < start && e <= end ->
      partial_start_overlap(range, mapping)
    SeedsRange(start: s, end: e) if s >= start && e > end -> partial_end_overlap(range, mapping)
    _ -> panic
  }
}

fn fully_outside(range: SeedsRange, _mapping: Mapping) {
  [[range], []]
}

fn fully_contained(range: SeedsRange, mapping: Mapping) {
  [
    [],
    [
      SeedsRange(
        start: range.start - mapping.source + mapping.destination,
        end: range.end - mapping.source + mapping.destination,
      ),
    ],
  ]
}

fn fully_contains(range: SeedsRange, mapping: Mapping) {
  let breaking_left = mapping.source
  let breaking_right = mapping.source + mapping.range - 1
  let contained = SeedsRange(start: breaking_left, end: breaking_right)
  let assert [[], contained_list] = fully_contained(contained, mapping)
  [
    [
      SeedsRange(start: range.start, end: breaking_left - 1),
      SeedsRange(start: breaking_right + 1, end: range.end),
    ],
    contained_list,
  ]
}

fn partial_start_overlap(range: SeedsRange, mapping: Mapping) {
  let breaking_point = mapping.source
  let contained = SeedsRange(start: breaking_point, end: range.end)
  let assert [[], contained_list] = fully_contained(contained, mapping)
  [[SeedsRange(start: range.start, end: breaking_point - 1)], contained_list]
}

fn partial_end_overlap(range: SeedsRange, mapping: Mapping) {
  let breaking_point = mapping.source + mapping.range - 1
  let contained = SeedsRange(start: range.start, end: breaking_point)
  let assert [[], contained_list] = fully_contained(contained, mapping)

  [[SeedsRange(start: breaking_point + 1, end: range.end)], contained_list]
}