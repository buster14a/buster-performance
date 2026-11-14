# #2541 step 2: external definitions, the single-site class, dead functions and the limits by sweep, on the 9700X (2026-11-14)

The measurement of step 2 of
[#2541's design](https://github.com/buster14a/buster/blob/main/docs/tier1-unit-inlining.md), in
[buster14a/buster#2713](https://github.com/buster14a/buster/pull/2713): external definitions join the always_inline and
small classes (but where another unit may replace them) and keep their own code; the single-site class (an internal
function with one direct call in the unit and nothing else keeping it, at most 2,048 instructions at a cost of 8,192);
the small class at 1,024 instructions and a cost of 256, by the sweep; dead functions (an internal candidate that no
emitted code refers to once its callers expanded it gets no code, in `-c` objects), held code and the emission's last
pass; every callee of a caller, not the first 64; a callee left out where any of its calls' signatures differs.

- **main:** `3482ab88f2b79c4a3d25f422073edc0da1360bed` (`9700x/main4.commit`) for the gate (q11), and
  `389d25b91a8bbc6faba040125be2ccad51b6815d` (`9700x/main2.commit`) for q8.
- **head:** `583e24997b912988a24605be67fecf4849768337` (`9700x/head4.commit`), the PR's head merged with main, for the
  gate; `71e9ee7540827171934e378ea8df06dd3d834169` (`9700x/head2.commit`) for q8. The PR's later commits change test
  fixtures and a test harness only. q1 to q7 measured the work in progress: `ca1ede6a` (`9700x/main.commit`) with
  `9700x/patches/head.diff`, then `head4.diff` (q6) and `head5.diff` (q7) applied, whose `BUSTER_X_*` variables were
  the sweep's knobs (the limits, the single-site class, holding).
- **Host:** AMD Ryzen 7 9700X, Linux 6.18.50, CPU 2 (governor and EPP `performance`), clang 23.1.1, perf 7.2.9
  (`9700x/host.txt`). Every build and run held the machine's lock, one hold per command (`scripts/lock.sh`,
  `scripts/queue.sh`, `9700x/q*.txt` and their logs).

The scripts are step 1's record's (`tier1-unit-inlining-step1-2541-2026-11-13/scripts`), extended: `programs.sh` and
`compile.sh` take `NAME=TREE[,VAR=VALUE][,+FLAG]` specifications, so that one tree gives `--tier1-no-inline`, the
experiments' knobs and `--tier1-no-hold`; `objects.sh` adds `--tier1-no-hold` to the lane comparison; `callers.sh`
samples the self-built compiler's call edges (`perf record -j any_call`). `scripts/summarize.sh` and
`scripts/compile-summary.sh` give the tables below (`9700x/summary.txt`).

## The gate

| Gate | Result |
| --- | --- |
| speedtest1 at least 12% fewer cycles | **met**: -14.61 (-15.06 to -14.16) against `--tier1 --tier1-no-inline`, faster at 8 of 8 placements |
| Lua at least 7.5% fewer cycles | **met**: -8.81 (-10.79 to -6.82), faster at 4 of 4 orders |
| no more `.text` than the prototype's largest limit (+64.6%, +66.3%) | **met**: speedtest1.o 1,021,532 to 1,632,764 bytes (+59.8%), Lua's units 223,816 to 329,062 (+47.0%); the target, that gain at half the growth, is not reached |
| the compiler built by `--tier1` at most 60 M returns | **at the edge**: 60.8 M and 60.1 M by two builds of the head (`perf-head4-tier1`, `perf-cyc4-tier1`), 59.8 M by `71e9ee75` (q8); 481.7 M without inlining, 139.4 M by main's |
| and at least 8% fewer cycles | **met**: 7,534 M against 8,458 M by the `--tier1-no-inline` build (-10.9%), three rounds; -2.2% against main's |
| a Csmith and YARPGen campaign of at least 1,000 programs by `--tier1`, `--tier1 --tier1-no-inline` and clang | **met**: see "The campaign" |

## Programs

speedtest1 at eight placements, Lua at four link orders, every executable's output checked first
(`results-q11/runs/checks.txt`), one warm-up and six measured rounds (`scripts/runs.sh`, two holds of three rounds).
As 100 ln(head / control) of user cycles, the mean over placements with its 95% interval (Student's t):

| Program | `--tier1-no-inline`, M | head, M | change | faster at | main, M | against main |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| speedtest1 | 871.5 | 753.0 | **-14.61** (-15.06 to -14.16) | 8 of 8 | 819.2 | -8.42 (-8.73 to -8.11) |
| Lua, five scripts | 1,107.7 | 1,014.4 | **-8.81** (-10.79 to -6.82) | 4 of 4 | 1,089.7 | -7.17 (-9.79 to -4.55) |
| calls.lua | 107.2 | 112.5 | +4.81 (-0.00 to +9.62) | 0 of 4 | 106.5 | +5.43 |
| tables.lua | 229.8 | 198.3 | -14.75 | 4 of 4 | 224.4 | -12.36 |
| strings.lua | 273.9 | 240.3 | -13.10 | 4 of 4 | 265.5 | -9.97 |
| arithmetic.lua | 170.3 | 165.6 | -2.85 | 4 of 4 | 173.0 | -4.39 |
| closures.lua | 326.4 | 297.7 | -9.21 | 4 of 4 | 320.3 | -7.32 |

`calls.lua` is the one script slower than main's at every limit measured: fewer instructions and branches and as many
misses as main's, an IPC loss in `luaV_execute`.

**An A/A run** came of a mistake: q11's `cyc4` was to be head with step 3's patch, which `git apply` didn't find (its
path was relative to the wrong directory), so `cyc4` is head built again in another directory. Against head: speedtest1
+0.00 (-0.53 to +0.53), Lua +0.76 (-0.81 to +2.33), `.text` the same bytes. q10 is void for the same reason worse: its
trees were copies of head2's with their CMake caches, which refused to build, and its runs timed head2's compiler three
times (`results-q10-void`, kept for the record; `scripts/build.sh` now fails loudly).

## The compile

`--tier1 -c` of the frozen sqlite3.c, one lane, CPU 2, seven measured runs in rotation after a warm-up
(`scripts/compile.sh`; `results-q11/compile`):

| | user cycles, M | instructions, M | task-clock, ms | `.text`, bytes |
| --- | ---: | ---: | ---: | ---: |
| `--tier1-no-inline` | 2,163.2 | 4,805.4 | 406.4 | 988,824 |
| main | 2,544.5 | 5,713.2 | 476.1 | 1,116,376 |
| head | 3,474.0 (+60.6%) | 8,677.2 | 644.6 | 1,584,072 (+60.2%) |
| head, `--tier1-no-hold` | 3,808.1 (+76.0%) | 9,401.8 | 704.8 | 1,584,072 |

The compile grows with the code, as the design claimed; holding the code of the candidates their callers expand saves
8.8% of it. **Objects** (`results-q11/objects-head4.txt`): sqlite3.c, speedtest1.c and Lua's 34 units, by the vector
path and the scalar twin, by one lane, eight, and eight with `--tier1-no-hold`: 72 of 72 the same bytes.

## The limits

The sweep of the small class's limits (q7, five rounds, against `--tier1-no-inline` of the same tree; `results-q7`):

| Limit (cost, size) | speedtest1 | Lua | speedtest1 `.text` | Lua `.text` | `-c sqlite3.c` cycles |
| --- | ---: | ---: | ---: | ---: | ---: |
| main (step 1) | -5.33 | -2.26 | +12.4% | +15.7% | +17.2% |
| 128, 512 | -13.67 | -6.16 | +43.0% | +20.8% | |
| 192, 768 | -13.93 | -7.66 | +48.9% | +36.0% | +52.3% |
| 256, 1,024 | -14.46 | -7.99 | +60.0% | +47.0% | +61.2% |

q1 and q5 swept before the signature fix (a caller whose any call of a callee mismatched its signature had its whole
unit refused by the inliner, `sqlite3VdbeExec` among them): `results-q8/runs-q1`, `runs-q5q6`. q2 to q4 measured the
compile with and without holding (`results-q8/compile-q2`, `compile-q3`, `compile-q5q6`).

## The compiler built by `--tier1`

The compiler's units at the scalar host compiled by each tree's `--tier1` (and `--tier1-no-inline`), linked by clang
(`scripts/selfhost-build.sh`), then compiling the frozen sqlite3.c, one lane, CPU 2 (`scripts/selfhost-runs.sh`, three
rounds, `scripts/selfhost-perf.sh`, three runs; `results-q11/selfhost`). The default tier's object is the same bytes by
every build; `--tier1`'s by every build of one tree.

| The compiler built by | default tier: cycles, M | returns, M | `--tier1` workload: cycles, M |
| --- | ---: | ---: | ---: |
| head's `--tier1 --tier1-no-inline` | 8,457.8 | 481.7 | 15,213.2 |
| main's `--tier1` | 7,705.0 | 139.4 | 12,219.9 |
| head's `--tier1` | 7,534.2 | 60.8 (60.1 by `cyc4`, the same source) | 13,971.3 |

The `--tier1` workload's work differs by tree (head's compile expands more of sqlite3.c), so only its control compares.
Where the remaining calls are (`results-q8/selfhost/callers-head2-tier1-edges.txt`, sampled call edges of q8's head):
`intern_hash_bytes_scalar`, `refine_intern_identifier`, `intern_find_or_add_hashed`, `refine_gap_is_splices` and
`lex_identifier_continue`, functions with several callers past the small class's limits, and the C library's `memcmp`
and `memcpy`.

## The campaign

`test-differential` campaigns (`local/campaign/campaign.sh`): Csmith (`0cdc7103`) and YARPGen (`1adb290f`) programs,
each compiled by `--tier1 --tier1-no-inline` (the harness's first mode) and `--tier1` (its second), both with
`-fno-asynchronous-unwind-tables`, and by clang -O0 and -O2, every executable's output compared. Run on the session's
container (an Intel Xeon), where the generators were built: four runs of 150 programs per generator (seeds 1000 to 1599)
by `71e9ee75`'s compiler, and two of 50 (seeds 1600 to 1699) by the final head's (`600fe962`)
(`local/campaign/results.tsv`, a line a program: run, generator and seed, status, signature):

| Compiler | Generator | programs | agreeing | clang -O0 link refused | clang -O0 timed out | clang -O0 output past the limit |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `71e9ee75` | Csmith | 600 | 515 | 0 | 78 | 7 |
| `71e9ee75` | YARPGen | 600 | 477 | 123 | 0 | 0 |
| `600fe962` | Csmith | 100 | 85 | 0 | 14 | 1 |
| `600fe962` | YARPGen | 100 | 80 | 20 | 0 | 0 |
| all | | 1400 | **1157** | 143 | 92 | 8 |

No program's buster builds differ from each other or from clang's. The others are the oracle's own: clang -O0 links
fail for YARPGen's arrays past the small code model's 2 GB (`relocation truncated to fit`), and clang -O0's executable
times out (30 s) or exceeds the output limit, so the harness counts them failed before comparing.

## Local, on the session's container

- `local/callgrind-counts.txt`: callgrind's instructions and calls of speedtest1 (`--size 2`) and Lua's five scripts by
  the variants the session built (`scripts/local/count.sh`, `programs.sh`), which chose what the 9700X then measured.
- `local/two-forms.txt` and `local/two-forms-experiment.patch`: the design's two forms (a wrapper's plain form copied
  into callers), measured and not adopted: on speedtest1 1.5% more instructions and 17.7% more `.text`, with 260 fewer
  dead functions.

## Reproducing

On the host, in a directory with these scripts: `./clone.sh COMMIT NAME` for main and head; then `queue.sh` of
`9700x/q11.txt` (each line takes the lock for one command); then `./summarize.sh none4 head4` and the others of
`9700x/summary.txt`.
