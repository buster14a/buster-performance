# Tier 1: blocks' lifetimes in promotion and selection by bottom-up rewriting (buster#141), 2026-11-02

Evidence for [buster#1117](https://github.com/buster14a/buster/pull/1117), which carries
[buster#1103](https://github.com/buster14a/buster/pull/1103)'s five commits (their record is
[buster-performance#215](https://github.com/buster14a/buster-performance/pull/215)) and adds:

- commit 6, `d1e8a5f`: a block's locals end at its lifetime's start. Promotion takes a slot's `lifetime start` as a
  write of the slot's undef, and Tier 1's CFG consumer moves nothing for a phi's undef operand. It fixes the regression
  #1103 reported: with floating values Tier 1 compiled Lua's `luaV_execute`, whose code ran slower than Tier 0's;
- commit 7, `153497c`: selection's vector path by bottom-up rewriting (BURS), #141's design item: pattern-state tables
  compiled by `tier1_select_initialize` (and baked), labeling 16 nodes a vector per depth level, top-down rule choice,
  maximal munch as the scalar twin and fallback;
- the review's commits `f4ab09e` and `7839e7a`: the grammar comment's figures at bounds 4, 8 and 16, and the cost of
  working the vector path's `costs` column out children first, which `7839e7a` removed.

Everything below ran on the Ryzen 7 9700X (benchpress), each build, test and measurement one hold of
`~/buster-fast-bench/exclusive.sh` (owner `claude-141-takeover`), every timed process pinned to CPU 2. The files are in
`9700x/`; lock-wait lines are removed from the logs, and the trees, executables, perf data and generated programs are
left out. `local/` holds the one file from the session's cloud container (below).

## Revisions, trees and setup

| Tree | Revision | What it is |
| --- | --- | --- |
| `t-c1c16f1d` | `c1c16f1df661a087be8595655e069de8fef29898` | #1103's first commit: before floating values, `luaV_execute` by Tier 0 |
| `t-0659328d` | `0659328d137d59fb9561bf00de9486c6f1375405` | #1103's head: floating values, the regression |
| `t-d1e8a5f2` | `d1e8a5f2f02f01d45950dac80fd15abbbefda094` | commit 6 |
| `t-burs` … `t-burs6` | `d1e8a5f2` + `burs.patch` … `burs6.patch` | commit 7's iterations (below); `t-burs6` is commit 7's code |
| `h-153497c4` | `153497c42375aa5765247fd3c4654afcf7449af9` | commit 7 as committed |
| `h-f4ab09ea` | `f4ab09ea2e6c18893f8376b47444e14260aa7655` | the review's first commit, with the children-first costs pass |
| `t-bound4`, `t-bound8`, `t-bound16` | `38881f5747c025caafb7e4094a772a96825f38d1` + `review.patch` | the review's tree at BURS bounds 4, 8 and 16 |

- `t-burs6` and `h-153497c4` differ only in comments (`tier1_select.c`) and in `docs/tier1-selection.md`.
  `identity.sh t-burs6 h-153497c4` compiles the frozen `sqlite3.c` and Lua 5.4.8's 34 sources by `--tier1 -c`, by
  both paths, with each tree: 70 objects identical, 0 differ (`identity-t-burs6-h-153497c4.txt`). So commit 7's rows
  measured on `t-burs6` are `153497c`'s code. `identity.sh t-burs t-burs6` gives the same (70 identical,
  `identity-t-burs-t-burs6.txt`): the iterations change how fast selection runs, not what it selects.
- Each tree was built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`build.sh`; logs in `logs-build/`).
- Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9.
- `common.sh` has the paths, the options and the lock's metadata.
- Inputs:
  - the frozen `sqlite3.c` (`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`, SHA-256
    `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), with
    `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`;
  - speedtest1 with that `sqlite3.c` (#136's unity harness, `speedtest1-unity.c`, SHA-256
    `eadb487f20f2bb4b383ad25078b0677a97d04f06204325cd9ab34665efbac1d5`), run as
    `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`;
  - Lua 5.4.8's 34 sources (the concatenation of its `src/*.c` and `src/*.h` has SHA-256
    `d547f17810fb28276ed06b38547e3119f2018b098e56df2421f3a1741f2ab494`) and five scripts (`lua/*.lua`);
  - #142's generators: Csmith `0cdc710315cfee9035e22ef4363ca479270d1934` and YARPGen
    `1adb290f453505838f3aa33dc571f292b0c1810f`.

## Commit 6: a block's locals end at its lifetime's start

### Lua 5.4.8 by `--tier1` (`lua.sh`, `lua/`)

Each tree builds the interpreter by `--tier1 -fno-asynchronous-unwind-tables`, and clang -O0 builds the outputs'
oracle. Every script's output by every build is clang -O0's (`lua/compare.txt`, all `same`; `lua/status.txt`, all 0).
Then 11 rounds, each one hold of the lock, run every build in an order that rotates by round (`lua/round.sh`,
`lua/times.txt`), and `perf stat` counts each script's user-space instructions once per build (`lua/stat-*.txt`).
Median wall time (ms) and range:

| Script | `c1c16f1d` | `0659328d` | `d1e8a5f2` | Instructions, `0659328d` to `d1e8a5f2` |
| --- | --- | --- | --- | --- |
| calls | 31.48 (31.43–33.53) | 50.29 (50.09–50.92) | 31.80 (31.25–34.00) | 1,575.8 M to 942.7 M |
| tables | 57.74 (57.18–58.35) | 57.62 (57.21–58.58) | 50.40 (49.98–50.73) | 1,818.7 M to 1,512.0 M |
| strings | 52.09 (51.79–52.21) | 55.77 (55.47–56.12) | 53.81 (53.63–55.16) | 1,277.0 M to 1,251.2 M |
| arithmetic | 67.51 (67.33–70.29) | 74.21 (73.92–74.94) | 57.85 (57.61–61.70) | 2,990.0 M to 2,158.3 M |
| closures | 73.36 (72.79–74.31) | 94.80 (93.81–97.18) | 71.35 (70.94–72.52) | 2,489.6 M to 1,893.3 M |

`c1c16f1d`'s instructions are 1,083.9 M, 1,709.3 M, 1,262.0 M, 2,450.4 M and 2,058.3 M in that order. Against it,
before floating values, where Tier 0 compiled `luaV_execute`, `d1e8a5f2`'s calls are level (the ranges overlap), its
tables, arithmetic and closures 3% to 14% faster, and its strings 3.3% slower with 0.9% fewer instructions.

`lvm.c` alone by `--tier1 --tier1-report -c` (`lua/report-lvm-*.txt`): Tier 1 compiles 17 of its 32 functions at
`c1c16f1d`, which refuses floating values, and all 32 at the other two:

| | `c1c16f1d` | `0659328d` | `d1e8a5f2` |
| --- | ---: | ---: | ---: |
| Tier 1's records | 1,465 | 19,441 | 12,174 |
| Spill stores | 0 | 969 | 718 |
| Values saved around calls (`call_stores`) | 70 | 2,967 | 304 |
| Edge moves | 50 | 4,819 | 2,939 |

At `c1c16f1d`, `luaV_execute` and the other functions with floating values are Tier 0's, so their records aren't in
Tier 1's counts. The PR's per-function figures
for `luaV_execute` alone (176 phis at the dispatch loop's header against 1; 16,803 records against 9,536; 2,842 values
saved around calls against 179; 967 spill stores against 716; 4,759 edge moves against 2,879) were counted in the
session's cloud container while diagnosing the regression, from the IR and from a temporary per-function line in
`--tier1-refusals` (`local/debug-print.patch`, never committed). They aren't reproduced on the 9700X here; the table
above is the same fix's evidence for the whole file.

### `sqlite3.c`, compile time and speedtest1 (`programs.sh 0659328d d1e8a5f2`, `programs-t-d1e8a5f2/`)

- `--tier1 --tier1-report --tier1-refusals -c` (`reports/`): Tier 1 compiles 2,666 of 2,668 functions at both
  heads; their records go from 347,789 to 346,753.
- `--tier1 -c` (`compile-tier1-ab.log`: `ab` of `time-runs`, 5 rounds of 21 runs a tree): the rounds' medians are
  477.19 to 477.39 ms at `0659328d` and 476.40 to 476.77 ms at `d1e8a5f2`. `perf stat -r 11`, three holds a tree
  (`compile-stat-*.csv`): 6,453.0 M against 6,438.6 M instructions (−0.22%).
- speedtest1 (`st/`): built by `0659328d`'s `--tier1` (`t1base`), `d1e8a5f2`'s `--tier1` (`t1`) and `d1e8a5f2`'s
  Tier 0 (`t0`). The `--verify` hash is `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` for every build
  (`verify-*.txt`). 11 rounds in a rotating order, each from a fresh database on tmpfs (`run.times`, `r*-*.txt`), and
  one `perf stat` run each (`stat-*.txt`):

| Build | Median wall | Range | Instructions |
| --- | ---: | --- | ---: |
| `0659328d` by `--tier1` | 208.87 ms | 208.46–210.47 | 3,932.9 M |
| `d1e8a5f2` by `--tier1` | 206.37 ms | 205.92–207.23 | 3,865.1 M |
| `d1e8a5f2` by Tier 0 | 257.17 ms | 256.40–257.92 | 5,694.2 M |

## Commit 7: selection by bottom-up rewriting

### Selection's cycles (`select.sh d1e8a5f2 burs4 burs6`, `select-burs6/`)

`benchmark-tier1-select-source` on the frozen `sqlite3.c`: 2,666 functions selected, 478,163 IR instructions. Each
process is one hold of the lock; five rounds run both paths in each tree, in an order that rotates by round
(`both-*.txt`). Medians of the five processes, in core cycles and instructions per IR instruction:

| | `d1e8a5f2` | `153497c` (`t-burs6`) |
| --- | ---: | ---: |
| Vector path | 261.69 / 689.96 | **224.99 / 503.22** |
| Scalar twin | 275.21 / 747.29 | 277.15 / 751.64 |

Every run reports the bottom-up rewrite's twin check on every selected function: `mismatches=0 uncovered=0`, 409,227
nodes by the rules' candidates and 92 by munch's fallback. Three more rounds time each path alone
(`select-t-*.txt`, `select-scalar-t-*.txt`) and the vector path after 200 ms of the scalar twin
(`select-after-t-*.txt`): the vector path takes 224.09 cycles alone and 224.88 after the scalar twin at `153497c`,
against 258.68 and 277.56 at `d1e8a5f2`; the scalar twin alone, 276.41 against 273.59.

### Commit 7's iterations (`select-burs1/` … `select-burs5/`, `burs*.patch`, `prof/`, `prof2/`)

Each iteration is `d1e8a5f2` with its patch, measured as above against `d1e8a5f2`. Medians of five processes,
cycles / instructions per IR instruction:

| Tree | Change | Vector path | Scalar twin |
| --- | --- | ---: | ---: |
| `t-burs` | the first BURS; `tier1_select_candidates` gets a second caller, which clang outlines | 228.57 / 512.09 | 304.54 / 841.19 |
| `t-burs2` | `tier1_select_candidates` and `tier1_select_munch` inlined by force | 227.20 / 523.50 | 296.98 / 819.46 |
| `t-burs3` | and its helpers (`canonical`, `load_folds`, `memory`) | 229.22 / 520.06 | 298.83 / 817.69 |
| `t-burs4` | the scalar level loop a function of its own (`tier1_select_cover_munch`) | 227.47 / 517.97 | 293.72 / 781.08 |
| `t-burs5` | one out-of-line copy of the candidates for both calls instead | 241.52 / 519.48 | 300.11 / 815.44 |
| `t-burs6` | `t-burs4`, with `tier1_select_add_candidate` inlined by force too: commit 7 | 224.99 / 503.22 | 277.15 / 751.64 |

`d1e8a5f2` measured 261.58 to 262.56 / 689.96 (vector) and 274.65 to 276.88 / 747.29 (scalar) in those rounds. `prof.sh`
and `prof2.sh` recorded `perf` per-symbol profiles (`instructions:u`) of `--only select-scalar` at `d1e8a5f2`,
`t-burs2`, `t-burs3` and `t-burs4` (reports in `prof/` and `prof2/`), which showed where the outlined candidates' calls
and spills went.

### `sqlite3.c`, compile time, speedtest1 and Lua (`programs.sh d1e8a5f2 burs6`, `programs-t-burs6/`; `lua-burs/`)

- Tier 1 compiles 2,666 of 2,668 functions at both; their records are 346,741 against 346,753.
- `--tier1 -c`: the rounds' medians are 476.54 to 477.01 ms at `d1e8a5f2` and 475.20 to 475.42 ms at `t-burs6` (the
  medians of the five rounds' medians: 476.62 and 475.23); 6,438.6 M against 6,345.3 M instructions (`perf stat`).
- speedtest1: `d1e8a5f2`'s and `t-burs6`'s `--tier1` builds run 206.72 ms (206.06–208.32) and 207.07 ms (206.46–207.77),
  both 3,865.1 M instructions; Tier 0's 256.46 ms. Every `--verify` hash is the one above. `programs-t-burs/` and
  `programs-t-burs2/` are the same steps for `t-burs` and `t-burs2`, whose `sqlite3.c` objects are `t-burs6`'s byte for
  byte.
- Lua (`lua-burs/`, `lua.sh` with `d1e8a5f2` and `t-burs`, whose 70 objects equal `t-burs6`'s above): every output is
  clang -O0's, and the scripts run alike (medians within 0.5%, overlapping ranges; instructions within 0.1%).

### #142's campaign at `153497c` (`campaign.sh`, `diff-h-153497c4/`, `diff-scalar-h-153497c4/`)

`test-differential` with `h-153497c4`'s build at both tiers (Tier 0, and `--tier1 -fno-asynchronous-unwind-tables`),
against clang -O0 and -O2, seeds 3400 to 3438 (two programs per generator a chunk, each chunk one hold of the lock),
by the vector path and again with `--scalar`. `campaign-tally.sh` (the
[reciprocal record's `tally.sh`](../tier1-reciprocal-141-2026-11-01/9700x/tally.sh)) writes `campaign.tsv`, a line per
program with every step's status; the chunk logs are kept.

- 80 programs; 60 pass at both tiers on both paths.
- The other 20 fail in clang -O0's own steps: 14 compiles (links that overflow its relocations), 2 compiles past the
  output limit and 4 runs past 30 s. Buster's steps: 14 compiles refused at both tiers (arrays past 2 GB, images past
  the executable's limits, calls of more than 239 arguments), exit status 1, and 4 runs past 30 s at both tiers.
- The vector run's `campaign.tsv` equals, sorted, the reciprocal record's
  [`head-cc3387f/campaign.tsv`](../tier1-reciprocal-141-2026-11-01/9700x/head-cc3387f/campaign.tsv) of the same seeds,
  every step's status included. The scalar run's programs, results and signatures equal the vector run's. (That
  record's own scalar campaign used seeds 3600 to 3638, so it isn't compared.)

## The review's figures

### The grammar's bound (`bounds.sh`, `bound*.txt`, `burs-bound*.diff`, `bound16-limits.*`)

The review's tree at bounds 4, 8 and 16 (`BUSTER_TIER1_BURS_BOUND`; the diffs against bound 8 are
`burs-bound4.diff` and `burs-bound16.diff`), each built and `test-tier1-select`'s summary printed:

| Bound | States | Most representers in a position | Pool entries | Build |
| --- | ---: | ---: | ---: | --- |
| 4 | 346 | 23 | 11,418 | passes; 582,584 checks, 0 failures |
| 8 (shipped) | 582 | 57 | 18,705 | passes; 582,584 checks, 0 failures |
| 16 | 1,430 | 173 | 47,735 | `bake-tables: an initializer failed` (`logs-build/t-bound16.log`) |

At bound 16 every one of the three is past the generator's limit (`BUSTER_TIER1_BURS_MAX_STATES` 1,024,
`BUSTER_TIER1_BURS_MAX_REPRESENTERS` 128, `BUSTER_TIER1_BURS_POOL` 32,768), so `tier1_select_initialize` fails and the
bake with it; `bound16-limits.sh` raised the limits to 4,096, 256 and 262,144 on a copy of `t-bound16` to measure the
row (`bound16-limits.txt`, 582,584 checks, 0 failures). The PR reply's statement that the 1,430 and 47,735 figures
"predate that bound and the current grammar" was wrong: they are this grammar's at bound 16. Only the comment's
21,777 was stale.

### The vector path's `costs` column (`select/`)

`select.sh f4ab09ea burs6`: `f4ab09e` worked the vector path's `Tier1SelectPlan.costs` out children first, a column
nothing reads. Medians of five processes of both paths interleaved, cycles / instructions per IR instruction:

| | `t-burs6` (`153497c`) | `f4ab09ea` |
| --- | ---: | ---: |
| Vector path | 222.88 / 503.22 | 241.30 / 514.05 |
| Scalar twin | 278.56 / 751.64 | 270.62 / 753.01 |

The pass took the vector path's selection 8.3% longer; `7839e7a` removed it and documents the column as the scalar
path's. Alone, the vector path took 222.57 against 241.02 cycles, and after 200 ms of the scalar twin 222.93 against
241.05.

## Correctness

The PR's 9700X CI job ran the full correctness inventory on `7839e7a`
([run 41455757799](https://github.com/buster14a/buster/actions/runs/41455757799)), after its hosted native and
baseline jobs. The commits' own tests are in their messages; `test-tier1-select` above runs the twin and table checks.

## Limitations

- The `luaV_execute`-only figures are the cloud container's, as said above; the 9700X's are `lvm.c`'s.
- One process per tree and round; the selection medians are of five processes, the compile-time medians of five
  rounds of 21 runs, and speedtest1's and Lua's of 11 runs. These are measurements of this workload, toolchain and
  machine only.
- The trees aren't kept here; each is its revision (and patch) as the table says.
