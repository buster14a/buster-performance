# Tier 0's unwind descriptor from its frame: the one-core path's step 4, piece 2 (buster#2874), 2026-11-21

[buster#2874](https://github.com/buster14a/buster/issues/2874)'s design
([7060520410](https://github.com/buster14a/buster/issues/2874#issuecomment-7060520410)) made its item 6 "the unwind rows
from the frame", and its plan after piece 1
([7061622474](https://github.com/buster14a/buster/issues/2874#issuecomment-7061622474)) made that piece 2, with this gate:
every `.eh_frame` byte the same, and the 1,419 cycles a body that a body's frame events and their resolution took
(`emitted_from_tier0` 662, the unwind lap 757, [the row record](../tier0-row-2874-2026-11-21/)) at 300 or less. This
record is the change in the compile against that gate. **The bytes are the same. The cost is 403 cycles a body where
main's is 1,512: 1,109 less, and 103 more than the gate.**

## What changed

On buster's branch `claude/gracious-heisenberg-s1u0t1`, on main `e77b3eba4752`:

- A Tier 0 frame of the fixed shape alone gets no frame events (`EmittedCode.frame_direct`): no probed reservation's
  loop, no preserved registers and no tail calls (`emitted_tier0_frame_direct`, which asks what `emitted_from_tier0`
  adds rows to that shape for). After branch sizing, `check_program_emit_frame_checked` makes its descriptor from the
  frame Tier 0 published, at the final offsets (`unwind_tier0_frame_tails` given the offsets, which checks each
  prologue and epilogue record against the frame, as it does where it makes the events). `--verify` compares it with
  Tier 0's fixed-frame analyzer (`unwind_tier0`, which reads the records alone), as it does any Tier 0 frame's.
- `unwind_tier0_frame_tails`' register loops visit the set bits alone, a frame's few pushes and pops, where they
  visited six and sixteen bits twice each, unrolled: the function was 1,869 instructions.
- `test-checker-driver`'s stack-clash section checks that Tier 0's frame of pages without a frame pointer has its CFA in
  r11 through the probes' loop (`readelf -wF`), which no test checked through the driver (the fault round below).

## How it was measured

- The 9700X, CPU 2, under the lock, a hold a run of 10 to 18 compiles (`scripts/rowlogab.sh`, `scripts/rowlogrep.sh`,
  `scripts/rowlog3.sh`): `-c sqlite3.c` with the frozen corpus's options, the row record's row log (`BUSTER_ROW_LOG`:
  each body's TSC ticks by part, and Tier 0's by pass, `emitted_from_tier0`'s lap being pass 15) and `--time-stages`.
- The experiment executable is `scripts/experiment.patch` on main `e77b3eba4752`: the change, the row log,
  `BUSTER_EXP_FRAME_EVENTS=1`, which makes every frame's events as main does, and `BUSTER_EXP_FRAME_REPEAT=N`, which
  makes a direct frame's descriptor N times. `results/p2ab1` and `results/p2rep1` ran it before the loops' rewrite
  (`scripts/change-v1.patch`, whose eligibility every `sqlite3.c` body met as well). Main's is the row record's
  `compiler-rowlog2`. Release `znver5` builds from a cloud container with CI's staged toolchain (LLVM 23.1.4),
  `binaries.sha256`.
- Each mode's runs in turn (ABBA, or `d e m`, `m d e`, `e m d`). A body's figure is its median over the runs, a part's
  the mean of the bodies'; cycles are TSC ticks times 5.45 / 3.7928. `scripts/fit3.py`, `scripts/abfit.py` and
  `scripts/repfit.py` read the logs (`results/*/rowlogs.tar.zst`).

## Results

**Bytes.** Every object is main's: `sqlite3.c` in every 9700X run and mode; and in the cloud, main against the change
(`scripts/compare.sh`, `results/cloud/compare.txt`), 5,572 compiles: `sqlite3.c` with and without `-g`, musl's 1,336
units with `-funwind-tables` with and without `-g`, every `tests/**/*.c` with `-march=znver5` and with `-g -O0`, and
c-testsuite's 220 programs with and without `-g`. 5,571 are the same, 3,649 of them with an `.eh_frame`; the other,
`tests/checker/weak-alias/mixed-unused.c` with `-g`, differs between two runs of main itself
([buster#3228](https://github.com/buster14a/buster/issues/3228)). `scripts/frames.c`, a function of each kind of Tier 0
frame, is the same under ten option sets (`scripts/fcmp.sh`). The correctness inventory's 30 blocks that name the
emission's, the unwind tables' and the driver's tests pass on the change with its check (`results/cloud/inventory.txt`;
`driver-parts.txt` has the driver's eight parts).

**Cost,** `results/p2final`, six runs of each mode; every one of `sqlite3.c`'s 2,602 bodies takes the direct path:

| cycles a body | main | this executable, frame events | this executable, the change |
| --- | ---: | ---: | ---: |
| `emitted_from_tier0`'s lap | 685.9 | 617.4 | 102.6 |
| the unwind lap | 826.2 | 850.1 | 300.2 |
| both | 1,512.1 | 1,467.5 | 402.7 |
| the unwind lap's a, fitted as a + b x the body's entries | 757 | 781 | 288 |

On `sqlite3.c` that is 2.887 million cycles less: 0.53 ms at 5.45 GHz, 4.03 cycles a token, 7.78 a typed entry.
`--time-stages`' medians read `tier0` 5.131 ms for main and 4.831 for the change, and `unwind` 0.488 and 0.234 (0.554 ms
less together); the whole compile read 119.630 and 118.442 ms, two executables apart.

**What moved it:**

- The events: in one executable before the loops' rewrite (`results/p2ab1`, five runs each), both laps 1,553.6 cycles a
  body with frame events and 516.6 without.
- The loops: a direct descriptor's warm cost, four more descriptors a body against none, 201.8 cycles each before the
  rewrite (`results/p2rep1`) and 157.6 after (`results/p2rep2`); the unwind lap 418.5 cycles a body before
  (`results/p2ab1`) and 300.2 after.

**Against the gate:** the bytes, met. 300 cycles a body or less: **missed**, 402.7. A lap with nothing in it reads 44.9
cycles a body (`debug`, without `-g`), and two laps hold the change's work; the descriptor itself costs 157.6 cycles
warm.

## The fault round

One executable with each fault behind `BUSTER_FAULT2874=N` (`scripts/fault.patch`, `scripts/faults.sh`): `frames.c`
against main, then the inventory's 30 blocks, stopping at a failure (`results/cloud/faults.txt`).

| fault | what it does | killed by |
| --- | --- | --- |
| 1 | a frame with a probed reservation's loop takes the direct path | `frames.c` alone; then the new stack-clash check, twice (`results/cloud/fault-1-with-the-check.txt`) |
| 3 | a preserving frame takes it | `test-checker-driver` part 4 of 8 (the preserving frames' programs crash) |
| 6 | a frame with tail calls takes it | `test-check-lanes` (its compile fails) |
| 7 | a naked function's code takes it | `test-checker-driver` part 4 of 8 |
| 8 | the descriptor reads the lane's previous body's frame | `test-calling-convention --cross-check` |
| 9 | the consumer resolves a direct frame's events, which it has none of | `test-calling-convention --cross-check` |
| 10 | `--verify` leaves out the analyzer's comparison for a direct frame | survives: the comparison fails only on a compiler bug, which no test makes |
| 11 | the adapter makes a direct frame's events anyway | survives: the bytes are the same, and the cost alone differs (the row log's frame-events mode) |

The eligibility's first form also asked for no eh_return and no preserved vectors or masks one by one; each was one
condition no frame separated from another (the lowering makes `__builtin_eh_return` a tail call, and Tier 0's
preserving frames keep their general registers, vectors and masks together), so it now asks
`emitted_tier0_preserved`, the count the adapter adds rows by.

## What it means

- The change takes back what #1056's frame events cost the default compile ([its
  record](../emission-cost-1056-2026-11-02/): `tier0` +0.24 ms and `unwind` +0.26 ms on `sqlite3.c`): 0.55 ms.
- The rest, 403 cycles a body, is a pass's cold start: a descriptor made once a body, by a function of checks that
  costs 158 cycles warm, between Tier 0's passes and the encoder's. The design's 0.5 cycles a typed entry (71 a body on
  `sqlite3.c`) needs the descriptors made a block of bodies at a time, or the frame's records checked by vectors, as
  the front's one loop a block would give them; neither is this piece.

## Files

- `scripts/experiment.patch`, `scripts/change-v1.patch`, `scripts/fault.patch`: the executables' sources, on main
  `e77b3eba4752`.
- `scripts/rowlogab.sh`, `scripts/rowlogrep.sh`, `scripts/rowlog3.sh`: the 9700X runs; `scripts/abfit.py`,
  `scripts/repfit.py`, `scripts/fit3.py`: their readings.
- `scripts/compare.sh`, `scripts/fcmp.sh`, `scripts/frames.c`, `scripts/faults.sh`: the cloud's comparisons and the
  fault round.
- `results/p2ab1`, `results/p2rep1`, `results/p2final`, `results/p2rep2`: the row logs (`rowlogs.tar.zst`), the stage
  clocks and the busiest processes around each hold; `results/cloud`: the comparisons, the inventory and the faults.
