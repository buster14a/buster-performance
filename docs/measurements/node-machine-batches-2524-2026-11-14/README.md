# buster#2524: the node machine's sweeps by batches (2026-11-14)

Claimed in [buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6884536598) as the lever the T
round left open ([`node-machine-t-dispatch-2524-2026-11-14`](../node-machine-t-dispatch-2524-2026-11-14)): an immediate
second run of an expression's three sweeps costs 123.5 cycles a taken node on `sqlite3.c` against 168.2 for a first
run, and running each sweep over a batch of expressions might keep its code in the caches.

**The result: no batching shape beats main on `sqlite3.c`, the gate's file. Batching T alone beats it on Lua and
musl. Weighted by each corpus's taken nodes the three come out about even, so the code is not merged.**

- **The code that gets warm is real:** with all three sweeps by batches of 256, the three sweeps' instruction-cache
  misses fall from 18.5 to 11.4 a taken node and their op-cache misses from 26.1 to 16.5.
- **Each sweep loses what the sweep before it, on the same expression, gave it:** mispredictions rise from 1.57 to
  2.19 a node, nearly all in C and X. A sweep runs cheaply right after the previous sweep went over the same
  expression's records. Batching T alone, with C and X still one expression at a time, keeps X's handoff from C, and
  C loses only T's.
- **T by batches of 256 (buster `a50a228`) against main:** `sqlite3.c` 176.5 against 170.8 cycles a taken node
  (+3.3%), Lua 137.5 against 146.9 (-6.4%), musl 125.7 against 131.2 (-4.2%). Weighted by the corpora's taken nodes
  (257,263, 57,779 and 110,119), +0.75 cycles a node.

## The code

[`patches/batches.patch`](patches/batches.patch) is the first version, buster `5d4c533`: all three sweeps by batches.
[`patches/t-batches.patch`](patches/t-batches.patch) is the second, buster `a50a228` (both on main `bb754cb8`): T by
batches, then C and X an expression at a time, the batches made once a file. Neither is merged; both are only here and
in the 9700X's checkout.

- **Records from a batch base.** `NodeMachine` keeps `base` and `end` in place of `count`. An expression's records are
  `base` to `end - 1` of its batch's, so T types a batch's expressions one after another in the columns, from base 0.
  `node_machine_select` gives C and X a batch's expression afterwards. `node_machine_run`, the census's comparison,
  keeps one expression alone at base 0.
- **The batch's own lists.** T's wide values and call arguments (and, in `5d4c533`, C's update plans) continue from the
  batch's earlier expressions', since C and X read them after T has typed the expressions that follow. A batch's first
  expression starts them.
- **The shadow's timing loop by batches**, `--batch N` (1 by default, at most 1,024 expressions, and a batch's records
  at most the machine's 4,096).
- **An exact check.** Under `--verify` with a batch above 1, the shadow runs the file's taken expressions alone and by
  batches and compares each expression's result: its refusal, the record it stopped at, its tape, its labels' entries
  and its calls' records, the last two from its base. The census test runs by batches of three.

## Runs

The 9700X (`benchpress`), each run on CPU 2 under the lock. The builds are Release, each a fresh worktree
(`scripts/build-label.sh`):

| label | revision | what |
| --- | --- | --- |
| `m3` | `bb754cb8` | main (#2775 merged) |
| `b1` | `5d4c533` | all three sweeps by batches |
| `m3o`, `b1o` | the same, with `patches/only-m.patch` and `patches/only-b.patch` | `BUSTER_NODE_SHADOW_ONLY=k` times sweep set k alone, for `perf stat` |
| `b1v` | `5d4c533` with `patches/order-b.patch` | `BUSTER_NODE_SHADOW_ORDER` picks which sweeps go by batches |
| `b2` | `a50a228` | T by batches, then C and X an expression at a time |

Figures are cycles a taken node, 11 passes, each sweep set's least: T alone, T and C (C is the difference) and all
three (X is the difference). `scripts/medians-b.py` takes medians over rounds.

## All three sweeps by batches (`b1`, three rounds, `scripts/job1.sh`)

Medians of three rounds (`results/m3/job1/`, `results/b1/`). Every round's all-three figure is within 2.4 cycles of
the median.

| batch | `sqlite3.c` T | C | X | all three | Lua T | C | X | all three |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 90.0 | 45.2 | 34.3 | **169.4** | 83.3 | 38.1 | 24.8 | **146.1** |
| 1 | 91.9 | 48.5 | 37.2 | 177.6 | 88.3 | 39.7 | 26.4 | 154.3 |
| 2 | 94.9 | 59.1 | 50.7 | 205.2 | 88.6 | 39.2 | 30.6 | 158.4 |
| 4 | 94.6 | 61.4 | 52.1 | 208.0 | 86.6 | 38.5 | 30.1 | 155.5 |
| 8 | 93.9 | 58.2 | 49.1 | 201.1 | 85.2 | 37.4 | 27.8 | 150.5 |
| 16 | 92.4 | 56.0 | 46.7 | 195.1 | 84.5 | 34.9 | 25.6 | 145.2 |
| 32 | 92.3 | 54.1 | 44.9 | 191.6 | 84.4 | 32.9 | 24.3 | 141.6 |
| 64 | 91.8 | 53.4 | 44.2 | 189.5 | 84.4 | 31.6 | 23.4 | 139.5 |
| 256 | 92.1 | 50.7 | 43.7 | 186.5 | 84.2 | 29.9 | 22.3 | 136.4 |
| 1,024 | 92.1 | 51.0 | 43.5 | 186.7 | 84.3 | 29.6 | 22.0 | 135.8 |

- **Batch 1 costs 8 cycles more than main** on both: T's loop keeps one more value (the base) live and spills, and
  the first timing loop did about 50 instructions an expression against main's 15. T runs 18.5 more instructions a
  node on `sqlite3.c`, C 7.1 more.
- **On `sqlite3.c`, batching costs at every size**, most at 2 to 8, where C and X are 13 to 15 cycles slower each.
- **On Lua it pays from 16 up**, 18 cycles under batch 1 at 1,024.

## What changes: counters (`b1o`, `scripts/counts-b.sh`, `scripts/counts-g.sh`)

`perf stat`, user mode, on `sqlite3.c`, each sweep set alone over 40 passes, less a run of none, a taken node
(`scripts/percounts.py results/b1o/counts 257263 -b1 -b16 -b256`; main's from `m3o`). The events come in three groups
of five, each group its own process. The rows are all three sweeps:

| | cycles | instructions | front-end-empty slots | L1i misses | mispredicts | op-cache misses | back-end-stall slots | L1d fills |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 168.8 | 559.7 | 581 | 16.6 | 1.56 | 25.2 | 154 | 2.57 |
| batch 1 | 175.2 | 582.9 | 607 | 18.5 | 1.57 | 26.1 | 168 | 2.58 |
| batch 16 | 194.8 | 582.6 | 684 | 16.2 | 2.25 | 24.6 | 190 | 3.13 |
| batch 256 | 187.2 | 577.5 | 585 | 11.4 | 2.19 | 16.5 | 200 | 6.32 |

- **The code stays warm:** at 256, C's L1i misses are 2.2 a node against 5.5 at batch 1 and X's 1.7 against 5.4.
- **The branches don't:** C's and X's mispredictions double (0.38 to 0.67, 0.42 to 0.74). A sweep's branches follow its
  expression's operators, and right after the previous sweep went over the same records the predictor's history holds
  them.
- **Data:** at 256 the batch's records no longer fit the 48 KB L1d: fills from L2 rise from 2.3 to 6.0 a node.
- **Per-set attribution at batch 16 is unreliable.** T alone ran 101.4 cycles in the counted runs against 92.4 in the
  timing runs, so C's counted figure there (set 1 less set 0) is low by the same amount. The all-three rows agree with
  the timings.

## Which handoff matters (`b1v`, `patches/order-b.patch`, two rounds, `scripts/job5.sh`)

`BUSTER_NODE_SHADOW_ORDER`: 0, all three by batches; 1, T over the batch, then C and X an expression at a time; 2, T
and C an expression at a time, then X over the batch. Medians of two rounds, within 1.8 cycles of each other:

| | batch | `sqlite3.c` C | X | all three | Lua C | X | all three |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| all by batches | 4 | 62.7 | 51.1 | 209.7 | 40.0 | 30.6 | 157.9 |
| T by batches | 4 | 62.4 | **36.6** | 194.0 | 40.8 | 26.9 | 154.4 |
| X by batches | 4 | **50.6** | 51.8 | 197.7 | 36.9 | 30.1 | 156.1 |
| all by batches | 16 | 56.3 | 47.5 | 197.4 | 35.8 | 26.7 | 147.8 |
| T by batches | 16 | 57.1 | **34.2** | 183.9 | 36.9 | 23.6 | 145.2 |
| X by batches | 16 | **47.8** | 47.6 | 189.2 | 35.8 | 26.3 | 149.7 |
| all by batches | 256 | 51.7 | 43.8 | 187.9 | 30.6 | 22.4 | 137.5 |
| T by batches | 256 | 51.6 | **31.5** | **175.0** | 32.0 | 21.0 | **136.9** |
| X by batches | 256 | **47.2** | 43.8 | 183.3 | 36.0 | 21.6 | 144.8 |

A sweep that runs right after the previous sweep on the same expression keeps batch 1's cost or better: C after T
(order 2) costs 47 to 51, C after other expressions' C 51 to 63; X after C (order 1) 31 to 37, X after other
expressions' X 44 to 52. With T by batches, X even beats batch 1's 37.2, since T's code no longer runs between one
expression's X and the next.

## T by batches (`b2`, `scripts/job6.sh`, `scripts/job7.sh`)

`a50a228` makes the batches once a file (`node_shadow_batches`) and runs C and X of an expression together, so its
timing loop costs about what main's does: batch 1 is 2.2 cycles over main on `sqlite3.c`, where `b1` was 8.2. C's
update plans are an expression's again, since X follows C at once. The runs: `scripts/time-g.sh` puts a round's twelve
runs (main and five batch sizes, on two corpora) in one hold; `scripts/time-musl.sh` gives each musl run its own hold,
on musl's 1,336 units (`corpora.sh`'s set and options from
[the T round](../node-machine-t-dispatch-2524-2026-11-14/scripts/corpora.sh)).

Medians, three rounds for `sqlite3.c` and Lua (`results/m3/time-b--*-r[123].txt`, `results/b2/`), two for musl. Every
round's all-three figure is within 2.7 cycles of its median.

| | `sqlite3.c` T | C | X | all three | Lua T | C | X | all three | musl all three |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 90.1 | 46.3 | 34.3 | **170.8** | 82.3 | 39.6 | 25.0 | **146.9** | **131.2** |
| 1 | 90.4 | 47.8 | 34.1 | 173.0 | 83.7 | 41.6 | 24.5 | 149.8 | 136.6 |
| 16 | 91.7 | 58.2 | 33.2 | 182.9 | 84.3 | 37.8 | 22.6 | 144.7 | |
| 64 | 91.7 | 55.6 | 31.9 | 179.3 | 84.6 | 34.7 | 20.6 | 140.1 | |
| 256 | 91.4 | 54.5 | 30.6 | 176.5 | 84.8 | 32.9 | 19.8 | 137.5 | 125.7 |
| 1,024 | 91.6 | 53.8 | 30.9 | 176.3 | 84.8 | 32.6 | 19.4 | 136.8 | 125.5 |

- **C moves opposite ways.** On `sqlite3.c` it costs 6.7 cycles more at 256 than at batch 1, without T right before
  it on the same expression; on Lua it costs 8.7 less, its code staying warm, and on musl 9.2 less (39.2 to 30.0).
- **X gains everywhere** (3.5, 4.7 and 2.3 cycles), right after C and with T's code no longer between one expression's
  X and the next.
- **Main's figures moved between the jobs** (169.4 and 146.1 in job 1, 170.8 and 146.9 in job 6): the same file, run
  hours apart. Each comparison above is within one job.

## The checks

- **`--verify` in the cloud container**, at batches 16 and 1,024 (`scripts/verify-local.sh`,
  `results/verify-cloud-b*.txt`): `sqlite3.c`, Lua 5.4.8 and musl's units, with and without `-g`. Values, entries and
  the twin agree with the pipeline, and no expression's result by batches differs from its result alone.
- **The check catches a broken batch.** With C's update plans started at every expression in `5d4c533`, 1,400
  expressions of `sqlite3.c` differed at batch 16; with T's argument list started at every expression in the final
  shape, 9,857.
- **`test-checker`** passes (`results/test-checker-cloud.txt`: 838,882 checks, 0 failures) and `./build.sh
  check-call-graph` finds 0 cycles (`results/check-call-graph-cloud.txt`).

## Traps

- **The 9700X's lock was congested** through the evening: runs that each took their own hold waited about five
  minutes a hold. `scripts/counts-g.sh` and `scripts/time-g.sh` put one batch size's runs, or one round's, of a few
  seconds each, in one hold.
- **`b1o`'s counted runs are taken less `m3o`'s run of none** (`counts-p0-setx-e*.txt` was copied before `b1o`'s own
  ran). That run times nothing; the two builds differ in it only by the census's comparison path, once an expression.
- **valgrind** runs only the x86-64 build, with `ulimit -v 67108864`: otherwise the checker runs out of address space
  ("the checker ran out of a resource"). Its instruction counts of the Develop build don't match the 9700X's Release
  build's (T's extra instructions at batch 1: 4.3 against 18.5 a node).
