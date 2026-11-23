# #2924 / #2699: the Tier 1 frame planner's scalar twin

The record of buster14a/buster's `claude/2924-frame` PR: the measurement on the 9700X that let the frame planner's
scalar twin (`tier1_frame_plan_scalar`, `Tier1EmitOptions.vector`) go, under the owner's rule 2 for #2924 (the vector
path at least as fast at every size, then the twin goes). Session: `session_01EgbxndFreFrJqAywiEGoue`.

Since #2763 the colorer itself is shared; the twin's arms left were the rows' scan (eight lanes against a scalar
loop), the classes (a register of eight keys against the radix sort), the event sort (ranks of up to 64 events
against the radix sort) and layout's class scan (an eight-lane prefix sum against a loop).

## How it was measured

On benchpress (Ryzen 7 9700X), `~/buster-fast-bench/2924-frame/`, every run under `exclusive.sh`:

- `setup.sh 968a085f`: main at `968a085f` plus `experiment.diff` (experiment only, never merged), Release, as
  `compiler-exp`. The diff adds to `tier1_frame.c` a knob that forces the path (`BUSTER_FRAME_SCALAR=1` scalar, `2`
  vector), a dump of every frame request (`BUSTER_FRAME_DUMP=FILE`) and a per-size TSC probe; and to
  `tier1_frame_benchmark.c` a `--replay FILE` mode that plans every dumped request once a pass, in compile order,
  through both paths, alternating which goes first, 21 passes, and prints the median TSC ticks a plan by object-count
  bin. It checks both paths' slots and offsets on every frame first (`mismatches`).
- `run1.sh`: `objects.sh` (#2924 C7's: `--tier1 -c --lanes 1` of sqlite3.c, Lua 5.4.8 and musl's units) with the path
  forced scalar and vector, objects compared; the vector run dumps the requests; then the replays (CPU 2), three
  rounds; then the in-compile probe and the synthetic benchmark by `--count`.

The replay is the honest per-size measurement: the synthetic `benchmark-tier1-frame` repeats one frame, which the
branch predictor learns, while a compile's frames never repeat (#2699's earlier record).

## Results

**Objects:** `logs/objects-summary.txt`: 1,371 objects compared, 0 differ (scalar against vector frame path).

**Replay, round 1** (`logs/replay-*-1.log`), vector ticks over scalar ticks a plan, by objects in the frame:

| bin | sqlite3.c | Lua | musl |
| --- | ---: | ---: | ---: |
| 0 | 0.923 (376) | 0.946 (118) | 0.964 (641) |
| 1 | 0.630 (205) | 0.643 (122) | 0.759 (280) |
| 2 | 0.546 (205) | 0.572 (142) | 0.471 (821) |
| 3-4 | 0.439 (247) | 0.453 (173) | 0.454 (249) |
| 5-8 | 0.375 (172) | 0.328 (59) | 0.384 (262) |
| 9-16 | 0.330 (101) | 0.306 (19) | 0.363 (114) |
| 17-32 | 0.400 (53) | 0.374 (4) | 0.434 (54) |
| 33-64 | 0.763 (21) | - | 0.786 (34) |
| 65-128 | 0.754 (6) | 0.824 (1) | 0.791 (20) |
| 129+ | 0.915 (2) | - | 0.839 (4) |
| all | 0.499 (1,388) | 0.488 (638) | 0.530 (2,479) |

Frames in parentheses. Every bin of every corpus is a vector win, 0.31 to 0.96; mismatches 0 in all three. Bins past 32
objects use the radix sort on both paths (more than 64 events), so they differ only in the rows and the layout scan.

Later rounds, the in-compile probe (`logs/probe-*`) and the synthetic counts (`logs/synthetic-*`) are added below as
they finish.

## Tests and mutation

The PR's tests commit replaces the twin comparison with checks that don't need the twin: preparation's class numbers
and event order against their definition, the colors against pointer jumping (already there), and a frozen FNV-1a
digest of every plan of the default run (`0x98e191af1dc9e33b`, the same before and after the deletion).

`mutation/`: 30 mutants of the vector code after the deletion, each built into a standalone `test-tier1-frame`
harness (`harness.c`) and run at the default seed and at seed 2 with two rounds (`run.sh`, `mutants.py`).
`round1.txt`: 26 killed, 4 survived. Three were real gaps, now tests in the PR's tests commit: an alignment of exactly
2^30 accepted, a stride of exactly INT32_MAX accepted, and an invalid row in a chunk's eighth lane. The fourth
(`classes-nine`) was a mutant that changed nothing. `round2.txt` (with the new tests, and `classes-seven` in place of
`classes-nine`): all killed but `classes-seven`, which is equivalent: a lower bound on the class register only sends
more frames to the radix sort, which gives the same classes.
