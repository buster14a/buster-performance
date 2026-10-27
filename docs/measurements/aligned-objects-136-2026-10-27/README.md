# Objects aligned past 16 bytes (#136): main against the branch, 2026-10-27

buster14a/buster's branch `claude/serene-merkle-0f3988`, which lifts Tier 0's and the producer's refusals of objects
aligned past 16 bytes for [buster14a/buster#136](https://github.com/buster14a/buster/issues/136) (realigned frames in
Tier 0; the producer's objects, parameters, variable-length arrays and structs by value aligned past 16), measured
against main on the 9700X (AMD Ryzen 7 9700X, Zen 5; Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2's
`performance` governor, boost on). Four of the branch's heads were measured; the pull request's numbers are the last
series', the branch with main merged in against that main.

## The trees

Each tree was sent as `git archive` of its commit; `manifest-TREE.sha256` lists every file, as `sha256sum` printed them
in the tree sent.

| Tree | Commit | Git tree | What it is |
| --- | --- | --- | --- |
| main | `b7b1f7af30c70a21766b4ac292b74e7be4e42508` | `69c9c9c7` | main for the first three series |
| head | `65b31ca7a1e82fbddb5c44d9b92dbedd2039fe61` | `e62c1f85` | realigned frames as first written |
| fix | `b5ea2dc8122b52214c65cf2d4fac066953623199` | `2f249255` | the selections take the frame's alignment as a constant, so that a function without a realigned frame or the memory classes has loops without it; the frame alignment's twins kept rolled (1,103 and 1,380 bytes in head, 126 and 287 here); the realigned prologue's records from a cold helper. Sent with head's `docs/tier0.md`, which the build doesn't read |
| final | `af005fc725e4c8b0e8991c22c39f596ff9f6aa23` | `2315e9f1` | the fix and a test program of `c_check_program_test.c`'s |
| mainpad | main's tree, changed | | the layout control: 14,928 bytes of `.skip` at the start of `tier0_benchmark.c`'s code (`queue-pad.sh` makes it) |
| main2 | `bbe59b7f4a5b635fa12fc875c6551e3a3dd40b7d` | `9683de41` | main for the last series, 54 commits past `b7b1f7af` |
| merged | `acb5131481a2470b29f0b551b76f33d35690ef8f` | `c6fcaa65` | final with main2 merged in: the pull request's head when measured |

## How each series ran

Each series' queue script (`queue.sh`, `queue-fix.sh`, `queue-final.sh`, `queue-merged.sh`; `queue-pad.sh` and
`queue-pad-scalar.sh` for the control) built its trees with `BUSTER_DEBUG_INFO=0 ./build.sh`, each build under a hold of
the shared lock (`~/buster-fast-bench/exclusive.sh`), and for the branch's later trees ran `test-tier0` and `test-unwind`
(`*-tier0.log`, `*-unwind.log`). It wrote each executable's defined symbols and sizes (`nm -S`) and their difference
with main's (`functions-diff*.txt`, `comm -3`: main's left, the branch's indented), took counters of whole
`benchmark-backend --only vector` processes, two of each tree in turn in one hold, pinned to CPU 2 (`perf stat -x, -e
cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u`;
`counters*/`: the fix's, final's and the last series' queues, final's and the last's of `--only scalar` too, in a hold
of its own; head's counters were a command of their own, `counters/command.sh`), then ran rounds of its round script
(`round.sh`, `round-fix.sh`, `round-final.sh`, `round-merged.sh`), each under one hold of the lock, the trees' order
alternating (main first in odd rounds), pinned to CPU 2:

- `benchmark-backend` (medians of 21 passes of the generated programs: 2,008 functions, 262,874 typed entries, 303,116
  records), the full run (`results*/backend-TREE-ROUND.txt`) and the vector path alone (`--only vector`,
  `results*/backend-vector-TREE-ROUND.txt`);
- `perf stat -r 11 -x, -e instructions:u,cycles:u,task-clock ./TREE/build/compiler -c -I$Q -o objects*/sqlite3-TREE.o
  $Q/sqlite3.c` (`results*/sqlite-TREE-ROUND.txt`), with SQLite 3.53.2's amalgamation from the frozen corpus
  `~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite` (`$Q`; `sqlite3.c`'s sha256 is
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), as the earlier #136 records
  (`sqlite-136-2026-10-26`, `backend-source-136-2026-10-26`) compile it.

Then it compared the two trees' last objects (`cmp`). `queue*.log` are the scripts' logs; their standard error, the
lock's waiting lines, which name other sessions' private links, is left out. `summarize.py RESULTS MAIN HEAD` makes the
round tables below from a `results*/` directory, and `counters.py DIRECTORY` the counters' from a `counters*/` one.

## The pull request's numbers: main2 against merged

`queue-merged.sh` built both trees, ran the merged head's `test-tier0` (206,571 checks, 0 failed) and `test-unwind`
(passed) on the 9700X, took the counters, then ran 6 rounds of `round-merged.sh` (`results-merged/`). Medians of the
rounds, [the fastest, the slowest]:

| Measure | main2 | merged | merged/main2 |
| --- | ---: | ---: | ---: |
| benchmark-backend, vector path: ns per entry | 14.54 [14.51, 14.58] | 14.52 [14.50, 14.57] | 0.998 |
| cycles per entry | 80.62 [80.45, 80.79] | 80.49 [80.36, 80.74] | 0.998 |
| instructions per entry | 169.85 | 170.86 | 1.006 |
| the vector path alone: ns per entry | 14.28 [14.25, 14.30] | 14.25 [14.21, 14.27] | 0.998 |
| cycles per entry | 79.12 [78.93, 79.27] | 78.96 [78.70, 79.06] | 0.998 |
| the scalar path: ns per entry | 41.62 [41.54, 41.63] | 42.04 [41.99, 42.09] | 1.010 |
| cycles per entry | 230.70 [230.21, 230.73] | 233.06 [232.70, 233.37] | 1.010 |
| instructions per entry | 570.95 | 573.75 | 1.005 |
| `-c sqlite3.c`: ms | 187.38 [187.13, 187.77] | 187.30 [187.03, 187.43] | 1.000 |
| instructions | 2,220,235,187 | 2,220,425,299 | 1.000 |
| cycles | 874,484,373 [873,045,747, 875,754,366] | 874,695,490 [874,034,759, 875,501,220] | 1.000 |

Both trees' `sqlite3.c` objects are the same bytes (`queue-merged.log`, `objects.sha256`).

The counters (`counters-merged/`), each tree twice, the second time in the other order:

| Tree | Path | ns per entry | Cycles | Instructions | Branch misses | L1i misses | ic_tag misses |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main2 | vector | 14.30, 14.29 | 693.8M, 692.0M | 1,576.8M, 1,576.9M | 9.17M, 9.21M | 4.64M, 4.58M | 45.0M, 45.5M |
| merged | vector | 14.27, 14.25 | 693.1M, 692.0M | 1,587.4M, 1,583.8M | 9.09M, 9.23M | 3.73M, 3.53M | 45.6M, 44.7M |
| main2 | scalar | 41.20, 41.21 | 1,505.0M, 1,503.5M | 3,753.0M, 3,753.3M | 25.13M, 25.14M | 2.93M, 2.93M | 62.2M, 65.0M |
| merged | scalar | 41.78, 41.68 | 1,523.2M, 1,521.1M | 3,768.6M, 3,769.5M | 25.23M, 25.17M | 2.50M, 2.35M | 40.3M, 39.5M |

On main2's layout the branch's vector path takes main's cycles with its 1.01 instructions per entry more (each
function's: the frame alignment's scan, the frame's added fields, the prologue's and the layout's checks of the
realignment), and has fewer L1i misses than main2, where against `b7b1f7af` it had more: main's 54 commits moved the
units' code, the benchmark's unit with it. The scalar twin's difference is 1.0% here against final's 3.8%, so most of
that was layout too (below).

## The earlier heads, against main at `b7b1f7af`

Medians of their rounds (head 3 and the fix 5, each queue stopped then for the next tree's; final 6), the ranges in
`summarize.py`'s output of `results*/`:

| Tree | Vector cycles per entry | Instructions per entry | Alone | Scalar cycles | Scalar instructions | sqlite3.c cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main (head's rounds) | 79.88 | 169.85 | 78.23 | 227.06 | 570.95 | 879,321,610 |
| head | 81.26 (+1.73%) | 170.64 | 79.72 (+1.90%) | 235.36 (+3.66%) | 574.54 | 874,886,410 (-0.50%) |
| main (the fix's rounds) | 79.87 | 169.85 | 78.23 | 227.22 | 570.95 | 880,460,734 |
| fix | 80.49 (+0.78%) | 170.86 | 79.19 (+1.23%) | 237.75 (+4.63%) | 573.75 | 874,619,399 (-0.66%) |
| main (final's rounds) | 79.78 | 169.85 | 78.19 | 227.10 | 570.95 | 879,637,087 |
| final | 80.69 (+1.15%) | 170.86 | 78.90 (+0.90%) | 235.75 (+3.81%) | 573.75 | 876,428,159 (-0.36%) |

Every tree's `sqlite3.c` object is main's, byte for byte: `queue-final.log`'s comparison, and for head and the fix, whose
queues were stopped before theirs, `objects.sha256`, the digests of each round's last objects taken afterwards.

## Where head's cycles went: counters and a layout control

The counters of whole `benchmark-backend --only vector` processes (generation and checks included; the benchmark's own
counter columns are disturbed by perf's and not used), two runs each (`counters*/`; for head's, `counters/both-runs.txt`,
the command's output, since its files kept only each tree's second run):

| Tree | Cycles | Instructions | Branch misses | L1i misses | ic_tag misses |
| --- | ---: | ---: | ---: | ---: | ---: |
| main | 687.8M, 686.7M | 1,578.5M, 1,577.4M | 9.09M, 9.07M | 3.41M, 3.43M | 43.8M, 43.9M |
| head | 699.4M, 698.8M | 1,584.5M, 1,585.5M | 9.24M, 9.25M | 3.91M, 3.91M | 48.2M, 48.2M |

Head's cycles came with 14% more L1i misses. The fix kept its new per-function code compact, but its L1i misses stayed
near head's (3.77M and 3.83M against main's 3.27M and 3.31M, `counters-fix/`). The benchmark's code is its own unit's,
`tier0_benchmark.c`'s, linked after `main.c`'s units, so any growth in them moves all of it: the fix's `tier0_compile`
there sits 0x3a50 bytes (14,928) past main's, `tier0_generate` 0x3560, `x86_encode_16`'s copies 0x37a0. The control,
`mainpad` (`queue-pad.sh`), is main's tree with 14,928 bytes of `.skip` at the start of that unit's code: no code
changed, `tier0_compile` at the fix's address (`addresses-*.txt`). `counters-pad/`, two runs each:

| Tree | ns per entry | Cycles | Instructions | L1i misses | ic_tag misses |
| --- | ---: | ---: | ---: | ---: | ---: |
| main | 14.12, 14.14 | 685.2M, 686.0M | 1,573.1M, 1,577.2M | 3.37M, 3.39M | 43.8M, 44.7M |
| mainpad | 14.24, 14.25 | 690.2M, 692.0M | 1,576.4M, 1,578.1M | 3.37M, 3.40M | 47.9M, 48.2M |
| fix | 14.31, 14.32 | 697.1M, 700.2M | 1,587.4M, 1,590.0M | 3.93M, 3.96M | 51.1M, 51.7M |

Moving main's code where the branch puts it costs the vector path 0.8% of its cycles with no code changed: about half
of the fix's difference. Most of the rest is the fix's ~1 instruction per entry more (each function's: the frame
alignment's scan, the frame's added fields, the prologue's and the layout's checks of the realignment).

The scalar twin, `--only scalar` (`counters-pad-scalar/`):

| Tree | ns per entry | Cycles | Instructions | L1i misses | ic_tag misses |
| --- | ---: | ---: | ---: | ---: | ---: |
| main | 40.69, 40.67 | 1,488.7M, 1,485.5M | 3,739.5M, 3,735.4M | 2.58M, 2.55M | 38.0M, 37.7M |
| mainpad | 40.92, 40.91 | 1,497.8M, 1,496.2M | 3,739.1M, 3,739.4M | 2.77M, 2.92M | 52.3M, 51.1M |
| fix | 42.55, 42.49 | 1,543.2M, 1,540.2M | 3,770.7M, 3,770.4M | 3.18M, 3.04M | 65.1M, 63.6M |

The scalar path's difference is mostly not the move (0.7% of its 3.7%): it comes with its own instruction cache misses,
in a `tier0_generate` of 46 KB in that unit, which inlines both selections, and whose hot loops the branch's few hundred
bytes moved within it. Not attributed further.

## Mutants

`mutants/` holds the mutation check, run on the laptop (a Ryzen 9 7940HS) while the first series ran: `make_mutant.py`
makes a copy of the worktree as it was then with one exact replacement, built at -O1, and `run_mutant.sh` builds it and runs the suites that must
catch it (`all*.sh`, in the order they ran). Each of the 14 mutants was caught; `mutants/results.txt` has each run's line.
The runs' own results file was lost with the laptop's `/tmp` (a reboot), so `results.txt` was put back together from the
session's transcript, which holds each line as the runner printed it, and says which failures were read in the logs by
hand.

## Limitations

- One machine; 3 to 6 rounds per tree, each of a full benchmark-backend run (21 passes), a vector-alone run and 11 runs
  of `-c sqlite3.c`, the trees' order alternating.
- The layout control moves one unit's code as a whole; the branch also moves functions within `tier0.c`'s code by its
  own growth, which no padding reproduces.
- The counters' runs are whole processes, the program generation and the paths' checks among them.
- Main moved between the series: compare each series' trees with each other, not across series (main2 runs the vector
  path at 80.62 cycles per entry and main at `b7b1f7af` at 79.78, from main's own changes and the layout they give).
- The generated programs have no object aligned past 16: these numbers are the cost to code without them. Code with
  them is checked for correctness (the pull request's tests), not timed here.
