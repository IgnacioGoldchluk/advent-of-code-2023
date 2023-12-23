import gleam/pair

pub opaque type HeapQueue(a) {
  HeapQueue(head: #(Int, a), subheaps: List(HeapQueue(a)))
  EmptyHeapQueue
}

fn delete_min(heapqueue: HeapQueue(a)) -> Result(HeapQueue(a), Nil) {
  case heapqueue {
    EmptyHeapQueue -> Error(Nil)
    HeapQueue(head: _m, subheaps: s) -> Ok(pair(s))
  }
}

pub fn empty(heapqueue: HeapQueue(a)) -> Bool {
  heapqueue == EmptyHeapQueue
}

fn meld(heap1: HeapQueue(a), heap2: HeapQueue(a)) -> HeapQueue(a) {
  case #(heap1, heap2) {
    #(x, EmptyHeapQueue) -> x
    #(EmptyHeapQueue, x) -> x
    #(HeapQueue(head: h1, subheaps: s1), HeapQueue(head: h2, subheaps: s2)) -> {
      case pair.first(h1) < pair.first(h2) {
        True -> HeapQueue(head: h1, subheaps: [heap2, ..s1])
        False -> HeapQueue(head: h2, subheaps: [heap1, ..s2])
      }
    }
  }
}

pub fn min(heapqueue: HeapQueue(a)) -> Result(#(Int, a), Nil) {
  case heapqueue {
    EmptyHeapQueue -> Error(Nil)
    HeapQueue(head: h, subheaps: _s) -> Ok(h)
  }
}

fn pair(subheaps: List(HeapQueue(a))) -> HeapQueue(a) {
  case subheaps {
    [] -> EmptyHeapQueue
    [h] -> h
    [h0, h1, ..hs] -> meld(meld(h0, h1), pair(hs))
  }
}

pub fn pop(heapqueue: HeapQueue(a)) -> Result(#(#(Int, a), HeapQueue(a)), Nil) {
  case heapqueue {
    EmptyHeapQueue -> Error(Nil)
    _ -> {
      // Guaranteed to succeed if the heap is not empty
      let assert Ok(m) = min(heapqueue)
      let assert Ok(new_heap) = delete_min(heapqueue)
      Ok(#(m, new_heap))
    }
  }
}

pub fn new(key: Int, value: a) -> HeapQueue(a) {
  HeapQueue(head: #(key, value), subheaps: [])
}

pub fn push(heapqueue: HeapQueue(a), key: Int, value: a) {
  meld(heapqueue, new(key, value))
}
