# Tier 1's code against clang -O2 at main `c5f0efb2`: the gap by cause, the first lever without an owner, and what blocks `-O1` (#138)

Measured 2026-11-12 for [buster#138](https://github.com/buster14a/buster/issues/138)
by one agent session (lock owner `claude-tier1-quality`), on the Ryzen 7 9700X,
every build and run inside one hold of `~/buster-fast-bench/exclusive.sh`, the
workloads pinned to CPU 2, clang 23.1.1, in a directory of its own
(`~/buster-fast-bench/138-tier1-quality-claude/`) with clean clones of
`buster14a/buster` at `c5f0efb20199618a542f0d8de61951916c15d76c`. The design that
these measurements serve is `docs/tier1-unit-inlining.md` in buster; this
record has the raw data, the scripts and the tables.

Nothing was fetched to or built on the 9700X that the repository's own jobs do
not fetch: the frozen corpora, speedtest1.c and Lua 5.4.8 by
`tools/ci/cached-download.sh` with their pinned digests, and the c-testsuite at
its pinned commit. Csmith and YARPGen were already installed there.

## What is here

| Directory | Contents |
| --- | --- |
| `scripts/` | every script and tool that produced the numbers, the tagging patch and the two experiment patches |
| `9700x/` | the 9700X's `results/` as written, with each result's lock holder line; `builds/` (build logs, commits, patch digests); `queues/` (the command queues and their logs). Other sessions' lock notices are removed from the logs |
| `callgrind/` | callgrind's counts of the 9700X's executables joined by #1189's `gap.c`: per-function rows (`*.tsv.gz`), call arcs (`*.arcs.gz`) and tables; `selfhost-ibs/` is the same join over IBS samples |
| `tables/` | generated tables (`scripts/tables.sh`): the three ladder runs, the calibration, the prototype, the compiler's builds, and the models' outputs |

## Method

- **Run times:** `measure-tier1-programs` (`scripts/programs.sh`), 11 rounds,
  with `--directory` on `/tmp` (tmpfs). A first run with the directory on disk
  made speedtest1's wall time I/O-bound (1.9 s) at the same cycles and
  instructions; it is kept as `9700x/main-disk`.
- **Instruction counts by cause:** callgrind with `--dump-instr=yes`, #1189's
  `gap.c` (from that record) and its tags, re-applied to current main
  (`scripts/kinds-instrumentation.patch`). The tagged compiler's executables
  are the timed ones byte for byte (`9700x/kinds-main/identity-programs.txt`).
  The 9700X has no valgrind, so callgrind ran in the session's container on
  the 9700X's executables through the 9700X's own `ld-linux`, `libc`, `libm`
  and `libdl` (`scripts/callgrind.sh`); whole-process totals agree with the
  9700X's `perf stat` within 0.4% on Lua and 1.6 to 2.5% on speedtest1 (the C
  library's `rep` loops). speedtest1 is counted without `--verify`, as it is
  timed.
- **The ladder:** `scripts/ladder-build.sh` builds speedtest1 and Lua by clang
  and by `opt` and `llc` in 58 configurations; `scripts/runs.sh` checks every
  build's outputs and times them (5 rounds, the order rotated and reversed by
  round).
- **The compiler as a program:** `scripts/selfhost-build.sh` compiles the
  compiler's 43 units at `BUSTER_HOST_ARCH=x86-64` by each tier, by clang and
  by the ladder's bottom pipelines; `scripts/selfhost-runs.sh` times each
  stage 2 compiler compiling the frozen `sqlite3.c` by its default tier and by
  `--tier1` after checking that every build writes the same object;
  `scripts/selfhost-perf.sh` counts returns and samples cycles by function.
- **IBS:** callgrind cannot run the compiler (its arenas' reservations), so
  its split by cause uses AMD's IBS op sampling (`scripts/ibs.sh`,
  `tools/ibs_callgrind.py`), validated on speedtest1 against callgrind below.
- **Placements:** an experiment's variants are compared over several
  placements of the same code, since a change moves every later function:
  speedtest1 as one object linked after 0, 528, ..., 3,696 bytes of nops, Lua
  as an object per unit linked in four rotations of its unit list.
  `tools/proto_table.py` reports 100 ln(variant / base) of user cycles with a
  95% interval over the placements' means, and over all pairs.

## Run times

`9700x/main/measure-tier1-programs.log`; all 330 runs succeeded.

| Program | Tier 0 | `--tier1` | clang -O0 | clang -O2 | tcc | `--tier1` / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1, ms | 255.0 | 186.2 | 294.4 | 131.2 | 271.6 | 1.42 |
| speedtest1, user cycles, M | 1,313.9 | 931.0 | 1,510.0 | 630.8 | 1,394.8 | 1.48 |
| speedtest1, instructions, M | 5,673.6 | 3,208.4 | 3,921.9 | 2,010.0 | 4,832.3 | 1.60 |
| Lua's five scripts, ms | 337.2 | 232.2 | 375.2 | 166.6 | 395.6 | 1.39 |
| Lua's five scripts, user cycles, M | 1,836.4 | 1,257.8 | 2,031.9 | 897.7 | 2,148.9 | 1.40 |
| Lua's five scripts, instructions, M | 10,770.4 | 6,114.0 | 8,332.0 | 4,283.3 | 9,392.2 | 1.43 |

The compiler built by each, compiling `sqlite3.c` (`9700x/selfhost/runs.tsv`,
`runs-ladder.tsv`, `runs-proto.tsv`; three rounds, medians; one object by
every build of a workload):

| The compiler built by | `-c`, ms | user cycles, M | instructions, G | `--tier1 -c`, ms | user cycles, M |
| --- | ---: | ---: | ---: | ---: | ---: |
| Tier 0 | 1,989.0 | 10,904 | 55.15 | 3,062.5 | 16,819 |
| `--tier1` | 1,610.0 | 8,795 | 32.92 | 2,388.4 | 13,070 |
| clang -O0 | 1,799.7 | 9,767 | 36.58 | 2,790.8 | 15,193 |
| clang -O2 | 570.0 | 3,054 | 10.58 | 954.2 | 5,161 |
| clang -O2 `-fno-inline` | 676.8 | 3,644 | 12.20 | 1,104.2 | 5,991 |
| `B` (the ladder's bottom) | 943.3 | 5,101 | 20.42 | 1,466.4 | 7,974 |
| `B` + LLVM's inliner | 749.6 | 4,045 | 16.97 | 1,243.6 | 6,762 |

Returns executed on `-c sqlite3.c` (`9700x/selfhost/perf-*-stat.csv`):
`--tier1` 345.4 M, Tier 0 282.2 M, clang -O0 249.1 M, `B` 474.8 M, clang -O2
`-fno-inline` 204.6 M, `B` + inliner 32.7 M, clang -O2 21.7 M.

## The gap by cause

`callgrind/main/st-table.md` and `lua-table.md` are `gap.c`'s tables: by
cause, by instruction type, by Tier 1's origin, and per function. The
program's own code: speedtest1 3,078.7 M instructions by `--tier1` against
1,918.4 M by clang -O2 (gap 1,160.3 M); Lua 5,577.0 M against 3,797.3 M
(1,779.8 M).

| Cause | speedtest1, M | share | Lua, M | share |
| --- | ---: | ---: | ---: | ---: |
| stack loads and stores | 273.4 | 23.6% | 300.7 | 16.9% |
| register moves | 215.8 | 18.6% | 478.6 | 26.9% |
| compares and branches | 152.4 | 13.1% | 290.2 | 16.3% |
| address arithmetic | 146.7 | 12.6% | 271.3 | 15.2% |
| calls, returns and frames | 131.8 | 11.4% | 60.8 | 3.4% |
| other loads and stores | 101.8 | 8.8% | 148.0 | 8.3% |
| constants | 101.7 | 8.8% | 38.3 | 2.2% |
| zero and sign extensions | 30.9 | 2.7% | 7.8 | 0.4% |
| arithmetic and the rest | 5.8 | 0.5% | 184.1 | 10.3% |

`callgrind/ladder/st-t1-vs-B.md` and `lua-t1-vs-B.md` are the same tables with
the ladder's `B` in clang's place (the same calls and passes as `--tier1`):
gaps of 810.3 M and 1,428.1 M. Calls into the programs' own code
(`*.arcs.gz`, `tools/arcs.py`): `--tier1` 68.92 M and 91.79 M, clang -O2
25.62 M and 54.20 M, `B` 68.92 M and 91.79 M, `B` + inliner 26.74 M and
54.71 M, clang -O2 `-fno-inline` 67.87 M (speedtest1).

**IBS against callgrind**, speedtest1's gap by cause in sampled operations
(`9700x/ibs/st-*.addresses.gz`, 40 runs each) and in callgrind's instructions:
register moves 17.8% and 18.6%; stack 22.3% and 23.6%; other loads and stores
8.1% and 8.8%; address arithmetic 12.5% and 12.6%; extensions 2.7% and 2.7%;
constants 8.3% and 8.8%; compares and branches 8.9% and 13.1% (a fused compare
and branch is one operation); calls, returns and frames 20.2% and 11.4% (a
call and a return are two operations each). The compiler's table by this
method is `callgrind/selfhost-ibs/table.md` (6 and 16 runs, each build's
samples scaled by the other's runs): `--tier1`'s build 3.18 times clang
-O2's operations.

## The ladder

`tables/ladder-top.md`, `ladder-bottom.md` and `ladder-inline2.md` have every
configuration: medians of time, user cycles, instructions and branch misses,
the ratio to clang -O2 and the share of the gap from `--tier1` to clang -O2
that the build closes. `9700x/ladder/builds.tsv` has each build's status and
`.text` bytes, and `scripts/ladder-build.sh` each one's exact recipe. A first
`ladder-top` run timed nothing (relative paths after a `cd`); it is kept as
`9700x/ladder-top-failed-paths`, and `ladder-inline` likewise failed its
builds and is superseded by `ladder-inline2`.

The rows the design uses (user cycles, M; `ladder-inline2`):

| Build | speedtest1 | Lua |
| --- | ---: | ---: |
| `--tier1` | 933.0 | 1,275.3 |
| `B` weak back end | 837.2 | 1,179.7 |
| `B` weak + inliner | 737.7 | 1,082.5 |
| `B` fast allocator | 991.4 | 1,408.1 |
| `B` fast allocator + inliner | 888.7 | 1,303.0 |
| `B` | 786.4 | 1,107.3 |
| `B` + inliner, threshold 10 / 25 / 50 / 100 / 225 / 500 | 722.2 / 705.9 / 698.3 / 686.7 / 680.5 / 670.0 | 1,059.0 / 1,070.9 / 1,060.0 / 1,017.5 / 978.1 / 956.9 |
| clang -O2 `-fno-inline` | 711.8 | 1,012.1 |
| clang -O2 | 632.9 | 902.7 |

## The calibration and the prototype

- `scripts/inline-static-experiment.patch` (`src-exp`): the existing inliner
  offered every internal function without an inline attribute
  (`BUSTER_EXP_INLINE_STATIC=COST`). `tables/calibration.txt`, `9700x/exp/`.
- `scripts/inline-cfg-prototype.patch` (`src-proto`): the block-level splice
  in `ir_optimize_inline.c` (`BUSTER_EXP_INLINE_CFG=1`), the unit's external
  definitions as candidates (`BUSTER_EXP_INLINE_EXTERNAL=1`) and the caller's
  growth limit (`BUSTER_EXP_INLINE_GROWTH`). With no variable set its code is
  main's. `tables/prototype.txt`, `9700x/proto/`; every variant's checks are
  in `9700x/proto/checks.txt` (speedtest1's hash at eight placements, Lua's
  five outputs in four link orders: 140 "same" lines and 56 hashes).

Variants: `s64` = `STATIC=64`; `cN` = `STATIC=N CFG=1`; `xN` = `cN` with
`EXTERNAL=1`. 100 ln(variant / base) of user cycles, with the 95% interval
over placements:

| Variant | speedtest1 | Lua | speedtest1 `.text` | Lua `.text` | calls, speedtest1 / Lua, M | `--tier1 -c sqlite3.c`, ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| base | 936.3 M cycles | 1,236.3 M cycles | 1,072,396 | 232,163 | 68.92 / 91.79 | 427 |
| `s64` | -3.28 (-3.90 to -2.66) | +0.54 (-1.10 to +2.17) | 1,068,012 | 232,019 | 60.23 / 90.64 | 685 |
| `c32` | -4.26 (-5.11 to -3.40) | +2.32 (-8.41 to +13.04) | 1,127,788 | 242,019 | 55.45 / 90.26 | |
| `c64` | -6.55 (-7.19 to -5.90) | -2.37 (-3.44 to -1.30) | 1,185,132 | 258,642 | 48.52 / 87.25 | 786 |
| `c128` | -9.09 (-9.75 to -8.44) | -6.30 (-9.13 to -3.48) | 1,390,970 | 291,908 | 40.29 / 77.50 | 1,056 |
| `x128` | -10.33 (-11.01 to -9.65) | -7.76 (-10.12 to -5.40) | 1,433,637 | 304,019 | 38.34 / 68.38 | 1,275 |
| `x256` | -12.82 (-13.40 to -12.23) | -7.89 (-10.38 to -5.41) | 1,764,724 | 386,153 | 29.72 / 58.50 | 2,196 |

The compile times are the prototype's per-caller arrangement
(`9700x/proto/compile-runs.tsv`, one lane), which the design replaces; the
calibration's own run gave 427, 602 and 680 ms at limits of 0, 32 and 64
(`9700x/exp/compile-runs.tsv`). The call counts are callgrind's of the
9700X's placement-0 executables (`callgrind/prototype/`).

The compiler built by the prototype (`9700x/selfhost/runs-proto.tsv`,
`perf-tier1cfg*-stat.csv`): `-c sqlite3.c` in 8,738.6 M cycles with
`always_inline` callees with control flow expanded and 8,535.5 M with small
internal functions too, against 8,807.6 M; 299.7 M and 223.4 M returns against
345.4 M; every build's objects the same bytes.

`9700x/bench/unit-stage.txt` is `tools/unit_stage_bench.c`: the call graph's
levels by Tarjan's traversal (66,500 cycles on speedtest1's 2,712 functions
and 9,025 edges) and by vector rounds (205,400), and the splice's operand
rebase by its scalar twin (2.4 to 2.8 cycles a node) and by vector (0.27 to
0.59).

Models from the measured arcs and tags, their outputs in `tables/models.txt`:
`tools/inline_classes.py` (calls by the callee's shape and size: straight-line
leaves, leaves with control flow, callees with calls), `tools/inline_model.py`
(what a size threshold removes, from the tags), `tools/inline_sites.py` (a
threshold by the site's loop depth: the sites in loops are 30% of the eligible
sites and make 32% of the calls), `tools/single_sites.py` (630 of
speedtest1's 2,415 internal functions have one direct call site and no address
taken: 24.4% of its instructions, 17.7% of its calls) and `tools/patterns.py`
(the patterns counted in Tier 1's instructions).

## The inventory for `-O1` and above (`9700x/inventory/`, `scripts/inventory.sh`)

| Part | Result |
| --- | --- |
| `sqlite` | `sqlite3.c` and `shell.c`: 3,214 of 3,214 functions by Tier 1 |
| `musl` | 1,355 units, none fails; 2,777 of 2,778 functions (`start` of `timer_create.c`, which calls `setjmp`) |
| `self` | the compiler at native flags: 38,527 of 38,544; 17 fallbacks (`self-refusals.txt`), no resource failure |
| `ctestsuite` | `test-c-testsuite --tier1` over the subset: 220 of 220 pass, 430 of 430 functions by Tier 1 |
| `determinism` | `--tier1` objects equal at 1 and 8 lanes; different by `--scalar` (sqlite3.o `.text` 1,037,688 against 1,037,736; `lvm.o` 30,788 against 30,812); Tier 0's equal by every path |
| `debug` | `--tier1 -g`: the same `.text`; `llvm-dwarfdump --verify` no errors, 10,521 warnings (the summary file); 681 ms against 426 ms; `.debug_loclists` 821,176 bytes against Tier 0's 182,762 |
| `verify` | `--tier1 --verify`: the same object; 2,153 functions certified, 68 uncertified, 447 not checked; 596 ms against 426 ms |
| `memory` | #1353's and #1384's shapes (`memory-runs.tsv`: status, wall, user and system seconds, peak RSS KiB): 8,000 loops 2,491 MB by `--tier1` against 83 MB by Tier 0; 16,000 operands of `\|\|` 1,126 MB against 76 MB |
| `compile` | `measure-compile`: `-c sqlite3.c` 124.0 ms by the default tier, 427.5 ms by `--tier1` (2,259.0 M against 598.9 M user cycles) |
| `clang-compile` | clang's `-c sqlite3.c` (`scripts/clang-compile.sh`): 8.48 s at -O2, 6.69 s at -O1, 0.56 s at -O0 |

`9700x/campaign/` is a Csmith and YARPGen campaign by `scripts/campaign.sh`
(#142's `test-differential`, both tiers against clang -O0 and -O2), seeds
13800 to 13837, four programs a chunk, each chunk one hold; `campaign.tsv` has
a line per program. Of 76 programs, 63 agree at both tiers with clang, and 13
are refused by the reference itself (clang -O0 fails to link YARPGen's largest
arrays in 6, passes the output limit in 3, and its program runs past the 30 s
timeout in 4); no mismatch.

## Reproducing

On the 9700X, in a new directory with `scripts/` copied into it:

```sh
./clone.sh c5f0efb20199618a542f0d8de61951916c15d76c src && ./build.sh       # build.sh takes the lock itself
./inputs.sh
./lock.sh ./programs.sh main
./kinds-build.sh && ./lock.sh ./kinds.sh main                              # then callgrind.sh off the host
./lock.sh ./ladder-build.sh && ./lock.sh ./runs.sh ladder-bottom 5 tier1=scratch/main O2=scratch/ladder/O2 B=scratch/ladder/B ...
./lock.sh ./selfhost-build.sh tier0 tier1 clangO2 clangO0 && ./lock.sh ./selfhost-runs.sh 3 tier0 tier1 clangO2 clangO0
./proto-build.sh && ./lock.sh ./proto-programs.sh base && ./lock.sh ./proto-programs.sh x256 BUSTER_EXP_INLINE_STATIC=256 BUSTER_EXP_INLINE_CFG=1 BUSTER_EXP_INLINE_EXTERNAL=1
./lock.sh ./proto-runs.sh 5 base x256
./lock.sh ./inventory.sh sqlite          # and each other part
```

`lock.sh` names this session as the lock's owner; another session changes its
three lines. `9700x/queues/q*.txt` are the exact command lines that ran, in
order, and `q*.txt.log` when each started and ended.
