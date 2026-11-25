# Probes

Patches applied to a copy of a tree's `src/` (`python3 PATCH.py TREE`), built by `../scripts/mkv.sh` or
`../scripts/mkpad.sh`; none is a candidate.

- `ceil.py` (on main `20f3573e`, `-DCEIL=1..4`): the block's parts. 1: no stores, the packed vectors folded into a
  sink. 2: the masks and the count only, no compress, no stores. 3: the loads, the class lookup and the stop mask
  only, the count advanced by a popcount of space edges. 4: four 64-byte stores of the bytes only.
- `dup.py` (on v3): the block's masks and compresses computed a second time from an opaque copy of its bytes, folded
  into a sink: what the block's arithmetic costs in the compile.
- `lat.py` (on v3): three dependent `imul $1` (9 cycles) on `limit`, the chain from a block's stop byte to the next
  block's address.
- `twice.py` (on any): every window lexed twice in a row, the second time over identical tokens.
- `prefetch.py D` (on v6): a `prefetcht0` D bytes ahead of each block's load.
