import day15
import gleeunit/should

pub fn day15_part1_test() {
  let test_input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

  day15.part1(test_input)
  |> should.equal(1320)
}

pub fn day15_part2_test() {
  let test_input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

  day15.part2(test_input)
  |> should.equal(145)
}
