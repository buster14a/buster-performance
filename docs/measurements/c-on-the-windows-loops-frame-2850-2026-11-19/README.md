# C on the window's loop's frame (buster#2850), 2026-11-19

What a step of C on the window's loop (`node_contexts_window_loop`, 64 records a step) keeps in its frame, and
four cheap changes that don't move it. Measurements only: nothing here is a pull request. PR buster#3030's record
(`a-conditions-branches-on-the-window-2850-2026-11-19`, `9700x/counters/`) has the harness: a group of four user-mode
counters (instructions, cycles, loads and stores dispatched) read around each of the loop's two runs of a chunk and
around nothing, by an experiment's patch.

The 9700X, CPU 2, Release, each run its own hold of the lock; three runs a build on `sqlite3.c` and on Lua
(`9700x/job-frame.sh LABEL...`, `9700x/frame-table.py`, `9700x/frame-table.txt`). All builds are PR buster#3030's
sources with the counters (`br2c`); `patches/loop-LABEL.diff` is each experiment's change to the loop's file on top
of that.

## 1. The readings

A block of 64 records, the loop's second run over the same chunk, medians of three runs:

| build | `sqlite3.c`: instructions | cycles | Lua: instructions | cycles | exact |
| --- | ---: | ---: | ---: | ---: | --- |
| `br2c`: the loop | 688.9 | 210.9 | 718.1 | 230.7 | yes |
| `br2p`: its three cold callees keep every register (`preserve_all`) | 698.2 | 209.8 | 726.8 | 227.0 | yes |
| `ord1`: each mask made where its vector is read (the source's order alone) | 687.9 | 213.4 | 717.1 | 229.2 | yes |
| `vw1`: operands as two view bytes a record: three gathers for ten, a test a mask, the columns' pointers read once | 691.4 | 209.2 | 722.1 | 228.5 | yes |
| `ool1`: `vw1`, and the scalar parts (strides, conversions, a type's space, far lanes, ranges) out of line, keeping every register | 746.1 | 224.0 | 773.1 | 244.1 | yes |
| `flr1`: no rule at all: the loads, the distances, the permutes, the rows and the stores | 188.4 | 82.3 | 185.7 | 65.8 | no (by design) |

"Exact": the shadow's comparison with C on T's columns reads the piece's counts (49,310 expressions decided on the
9700X's `sqlite3.c`, 10,079 on Lua) and no difference. `flr1` makes no rule and is compared with nothing.

The first runs are in `frame-table.txt`: on `sqlite3.c` 276.8 to 286.9 cycles a block for the first four builds, 315.3
for `ool1` and 93.5 for `flr1`.

## 2. What the loop's instructions are

`9700x/asm/mix.txt` (`mix.py`), the 819 instructions of the loop's main body in `br2`'s build:

| | |
| --- | ---: |
| vector mov, load, store, broadcast (93 `vmovdqa64`, 30 `vbroadcasti32x4`) | 162 |
| general mov, cmov, lea (138 `mov`) | 154 |
| general logic (`and`, `or`, `andn`) | 130 |
| `kmovq`: a mask to or from a general register or the frame | 124 |
| vector compare or test into a mask | 78 |
| other vector | 60 |
| mask-register logic | 41 |
| other general | 34 |
| branch, compare, call | 21 |
| vector permute | 15 |

`9700x/asm/slots.txt` (`slots.py`): 108 writes to the frame and 148 reads a step in `br2`, `ord1` and `vw1` alike;
87 and 125 in `ool1`; 4 and 8 in `flr1`.

## 3. What it says

- **The calls are not the cause** (`br2p`), nor the order the source makes the masks in (`ord1`: the compiler orders
  them itself), nor the ten gathers (`vw1`), nor the scalar loops inside the step (`ool1`, which costs more: its
  strides' function is called for the 7,490 records whose stride `sqlite3.c`'s 5,337 blocks read).
- **The rules are some 500 instructions and 130 cycles a block over a floor of 82** (`flr1`). Of the loop's 819
  instructions 440 are moves: of a vector, in general registers, or of a mask between the two. The rules' masks are
  64-bit integers to the compiler, which combines them in general registers and keeps them in the frame: 108 writes and
  148 reads a step.
- **What is left is the masks' network itself.** One way: the rules as table lookups (a byte of rule bits by an AND
  of lookups of each source's byte, or a class's needs tested against predicate bytes), which keeps the logic in
  vector registers. Estimated at some 290 instructions a block, not built: its own piece, with its own specification,
  if it is taken.
