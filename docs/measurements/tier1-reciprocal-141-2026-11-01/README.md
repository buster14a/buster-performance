# Tier 1's division by a constant, and #141's Done-when measurements (2026-11-01)

Evidence for [buster#1001](https://github.com/buster14a/buster/pull/1001), which divides by a constant that isn't a
power of two by multiplying by its reciprocal (Granlund and Montgomery), and for
[buster#141](https://github.com/buster14a/buster/issues/141)'s Done-when items: instruction counts and run time against
Tier 0 and clang -O2 on the corpora's programs and speedtest1, selection's cycles per IR instruction for both paths, and
#142's campaigns. By Claude, at David's request.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `6490b102` | main at the branch point |
| head | `e0ae799c` | the reciprocal division (`TIER1_RULE_DIVIDE_RECIPROCAL`), its tests and both consumers' fixed registers |
| final head | `1ea8b028` | `e0ae799c`, the loop fixtures in a bounded child (`097e84d`), the fixed registers' path out of line (`c12fa29`), `benchmark-tier1-select-source` (`1ea8b02`) |
| new base | `051de9c6` | main with buster#996 (#982: a frame object's address in its users' memory operands) |
| merged head | `cc3387f4` | the final head with the new base merged |

Each 9700X tree was a `git archive` of its commit (`9700x/receipts.txt`: each tree's file hash, equal to its commit's
archive, and its `build/compiler`'s). Two experiment trees are committed nowhere: `exp-verify-1ea8b02` is `1ea8b02`
with `9700x/verify-experiment.diff` (the selection benchmark's two more variants, `ir_verify` alone), and
`exp-select-051de9c` is `051de9c` with `9700x/select-graft.diff` (`benchmark-tier1-select-source` grafted on, to time
the new base's selection).

## Commands

On the 9700X, every build, test and timed run one hold of the shared lock, timed runs pinned to CPU 2. The scripts are
in `9700x/` (`common.sh` holds the paths, the frozen inputs and the lock's owner):

- `queue-1.sh 6490b102-tree e0ae799c-tree REVISION`: both builds (`build.sh`, `BUSTER_DEBUG_INFO=0`), the head's tests
  (`tests.sh`), the division micro-benchmark (`micro.sh`, `micro.c`), the main-against-head measurements
  (`measure.sh`), then #142's campaigns (`campaign.sh`) at the head.
- `queue-2.sh BASE e0ae799c-tree 1ea8b02-tree`: the final head's build and tests, the compile-time comparison against
  the base, whether its `--tier1` code is `e0ae799c`'s byte for byte, and `benchmark-tier1-select-source`.
- `corpora.sh 1ea8b02-tree`: Lua 5.4.8's interpreter, c-testsuite's subset and speedtest1, each built by six compilers
  and run; `empty-lm.sh` (c-testsuite's startup baseline), `st-static.sh` (speedtest1's static counts) and
  `corpora-summary.sh` (the tables) after it.
- `select-profile.sh`, `verify-experiment.sh` and `lua-profile.sh`: where selection's and Lua's cycles go.
- `queue-4.sh 051de9c-tree cc3387f-tree REVISION`: the merged head against the new base, as `queue-1.sh`, with
  campaign seeds no earlier campaign used.
- Where `--tier1 -c`'s extra time goes: `placements.sh` (the comparison over code placements of a unit),
  `cost-profile.sh` (counters and samples by symbol) and `select-compare.sh` (selection, the new base against the merged
  head).
- `tally.sh` (one line per campaign program, every step's status), `micro-summary.sh`, `receipts.sh`, and `collect.sh`,
  which copied the logs here.

The six compilers: buster's Tier 0 (the default), `--tier1 -fno-asynchronous-unwind-tables` and `--tier1 --scalar
-fno-asynchronous-unwind-tables`, clang 23.1.1 at -O0 and -O2, and tcc 0.9.28rc (2026-01-17). Buster's Tier 0 builds
keep their unwind tables; its `--tier1` builds can't have them yet. The logs leave out the lock's waiting messages,
which name other sessions' and CI jobs' commands.

Locally (`local/`, this session's AVX-512 Xeon container, not the 9700X):

- `math/`: the check that preceded the compiler code. `magic_check.c` simulates Granlund and Montgomery's
  CHOOSE_MULTIPLIER and the planned sequences with exact 32- and 64-bit register semantics against C's `/` and `%` (`cc
  -O2 -pthread -o magic_check magic_check.c && ./magic_check exhaustive`, `exhaustive.log`). It checks every divisor
  from 2 to 65,536 and its negation at both widths, 30 large divisors 64 times each, and 2 million random values at both
  widths, each on 34 dividends at its edges (0, 1, the extremes, the divisor and its multiples nearest them, and random
  ones), quotient and remainder, unsigned and signed: 554,670,560 checks. Then every 32-bit dividend for 16 divisors (3,
  5, 6, 7, 10, 12, 14, 25, 641, 0x7fffffff, 0x80000001, 0xfffffffe, 0xffffffff, −7, −3 and −10, signed where they are
  eligible). It found no failure. `longest.c` (with `params.h`) counts the sequences' records.
- `mutants/`: `mutants.py` builds each mutant by recompiling the backend unit of a mutated tree and relinking it with
  the head's other objects, then runs `test-tier1-select` and `test-tier1-emit` (`run.log`); every mutant fails one.

## Inputs

- SQLite: the frozen `sqlite3.c` and SQLite 3.53.2's `test/speedtest1.c` (#136's harness, its flags and options; the
  database on tmpfs), by the hashes in `receipts.txt`.
- Lua 5.4.8: lua.org's `lua-5.4.8.tar.gz` (SHA-256 `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae`),
  extracted unchanged; an external input, not included here. Its interpreter is `lua.c` and the library's 32 sources,
  as its Makefile's `linux` target builds them: `-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, linked with `-lm -ldl`
  (tcc without `-std=gnu99`, which it doesn't take). The five scripts in `9700x/lua/` are original: recursive calls
  (`calls`), a sieve, a sort with a comparator and string keys (`tables`), formatting and patterns (`strings`), digit
  sums by `//` and `%` and a Mandelbrot set (`arithmetic`), and metatables, closures and coroutines (`closures`).
- c-testsuite at `5c7275656d751de0e68b2d340a95b5681858ed07`: buster's `tests/c-testsuite/subset.txt`, all 220 of its
  single-exec programs, each compiled with `-lm` and run against its expected output.
- #142's generators: Csmith `0cdc710` and YARPGen `1adb290`, two programs per generator a hold, each compared against
  clang -O0 and -O2.

## Correctness

| Check | Result |
| --- | --- |
| Tier 1's suites at `e0ae799c`, `1ea8b02` and `cc3387f` (`tests.sh`) | 0 failures in each; c-testsuite's subset by `--tier1` 220 of 220; the call graph 0 cycles, 0 split variables; the compiler's own `main.c` by `-fsyntax-only`, `-c --verify` and `--tier1 -c` |
| c-testsuite's 220 programs by the six compilers | 220 of 220 by each |
| Lua's five scripts by the six builds | every output clang -O0's (`9700x/corpora-1ea8b02/lua/compare.txt`) |
| speedtest1 `--verify`, every build of every head | `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` |
| #142 at `e0ae799c`, Tier 0 and `--tier1`, seeds 3000 to 3039 | 80 programs: 66 pass; 14 fail in clang's own steps (9 links past the small code model, 2 compiles past the output limit, 3 runs past 30 s), none in Buster's |
| #142 at `e0ae799c`, Tier 0 and `--tier1 --scalar`, seeds 3200 to 3219 | 40 programs: 36 pass; 4 fail in clang's own steps (3 links past the small code model, 1 run past 30 s under clang -O0), none in Buster's |
| #142 at `cc3387f`, Tier 0 and `--tier1`, seeds 3400 to 3439 | 80 programs: 60 pass; 20 fail in clang's own steps (14 links past the small code model, 2 compiles past the output limit, 4 runs past 30 s), none in Buster's |
| #142 at `cc3387f`, Tier 0 and `--tier1 --scalar`, seeds 3600 to 3619 | 40 programs: 33 pass; 7 fail in clang's own steps (3 links past the small code model, 4 runs past 30 s under clang -O0), none in Buster's |

So of the 240 programs, 195 pass at both tiers and the 45 others fail in clang's own steps. Where clang's link fails
(relocations truncated: YARPGen's arrays past 2 GB), Buster refuses the program too: an atom past 2 GB, an image past
the executable's limits, or a call of more than 239 arguments. Where clang's compile writes past the output limit
(Csmith's warnings), both of Buster's tiers compile and run the program, but there is no reference to compare them
with. Where clang -O0's run passes 30 s, both of Buster's tiers' runs do too; clang -O2's finished one of those programs
(seed 3211), passed 30 s on 9, and stopped on SIGSEGV after about 50 ms on 2 (seeds 3602 and 3609). The campaigns'
per-program steps are in `9700x/head-*/campaign*.tsv`.

## The reciprocal division, main against head

**The division micro-benchmark** (`micro.c`): five kernels, ns per division, each build's median of 11 rounds, a round
being the best of 7 trials; a chain's divisions each wait for the one before, a stream's are independent. Every run's
checksum is `02219caec48f7d11`.

| Kernel | Tier 0 | `--tier1`, base | `--tier1`, head | clang -O2 |
| --- | ---: | ---: | ---: | ---: |
| chain, `u64 / 10` | 3.074 | 3.065 | 1.081 | 1.081 |
| chain, `s32 / 7` | 2.524 | 2.523 | 1.621 | 1.756 |
| chain, `s64 % 1000003` | 3.424 | 3.424 | 3.065 | 2.703 |
| stream, `u32 % 10` | 1.086 | 1.086 | 0.494 | 0.380 |
| stream, `s64 / 1000` | 1.859 | 1.771 | 0.421 | 0.330 |

At `cc3387f` against `051de9c` every figure is within 0.002 ns of these (`9700x/head-cc3387f/micro/summary.txt`).

**speedtest1**, ms, medians of 11 rounds (ranges), and `perf stat` of one run each:

| Build | `6490b102`/`e0ae799c` | `051de9c`/`cc3387f` | instructions (`e0ae799c`) | cycles |
| --- | ---: | ---: | ---: | ---: |
| Tier 0, head | 256.4 (255.9–257.1) | 255.8 (255.1–256.8) | 5,694 M | 1,320 M |
| Tier 0, base | 255.9 (255.4–256.5) | 255.8 (255.3–256.4) | | |
| `--tier1`, base | 221.8 (221.5–222.6) | 222.6 (221.8–223.0) | 4,411 M | 1,130 M |
| `--tier1`, head | 222.4 (221.5–222.7) | 222.6 (222.2–223.6) | 4,413 M | 1,134 M |
| `--tier1 --scalar`, head | 220.7 (219.7–221.6) | 222.0 (221.7–223.5) | 4,432 M | 1,127 M |
| clang -O0 | 294.1 (293.4–295.4) | 295.1 (294.0–295.8) | | |
| clang -O2 | 132.0 (131.5–132.8) | 131.4 (131.0–131.8) | 2,010 M | 638 M |

speedtest1's run time doesn't change: its hot Tier 1 code hardly divides by constants. Head's `--tier1` executable has
378 `div`/`idiv` against base's 461, and 83 one-operand `mul`/`imul` (base's has none). `--tier1-report` of the frozen
`sqlite3.c`: the same 2,181 functions by Tier 1, 166 more records (148,252 against 148,086 at `e0ae799c`, 148,152
against 147,986 at `cc3387f`), the same spills, call saves, edge moves and recomputed constants.

`1ea8b02`'s `--tier1` code is `e0ae799c`'s byte for byte, by both paths: the objects of `sqlite3.c` and speedtest1's
executables (`9700x/head-1ea8b02/same.txt`). So `e0ae799c`'s run-time figures hold for it.

**Compile time**, `time-runs` medians per round in ms, 5 rounds of 21 runs (`ab`, each tree's range over its rounds):

| Command | base `6490b102` | head `e0ae799c` | base again | head `1ea8b02` | new base `051de9c` | merged head `cc3387f` |
| --- | --- | --- | --- | --- | --- | --- |
| `-c sqlite3.c` | 133.44–133.60 | 133.46–133.74 | 133.52–133.72 | 133.94–134.07 | 133.50–133.67 | 133.40–133.84 |
| speedtest1's direct-path link | 137.36–137.63 | 137.38–137.52 | | | 137.42–137.65 | 137.50–137.81 |
| `--tier1 -c sqlite3.c` | 371.64–371.82 | 372.25–372.55 | 371.34–372.29 | 372.01–372.42 | 372.39–372.83 | 374.13–374.43 |

The default path runs none of the changed code: its instructions are base's to within 15,000 (0.001%) at every head.
`--tier1 -c sqlite3.c` runs 4.27 M more instructions (+0.086%) at `e0ae799c` and at `1ea8b02`, and 4.30 M (+0.087%) at
`cc3387f`; moving the fixed registers' path out of line (`c12fa29`) didn't change that. Its time, one executable per
tree, is +0.17%, +0.18% and +0.45% at the three heads.

The +0.45% is the checker unit's placement. `placements.sh` (docs/profiling.md's method) builds each tree with a unit's
code at six offsets, runs each executable from three fresh copies, and compares main, the head and main again, in three
rounds:

| Unit shifted | Head against main, user cycles | Over its placements | Main again against main |
| --- | --- | --- | --- |
| `main_unit_checker.c`, which holds the driver that runs `--tier1` | +0.03%, +0.05%, +0.16% | −0.48% to +0.61% | −0.07% to −0.02% |
| `main_unit_backend.c` | +0.51%, +0.48%, +0.43% | +0.19% to +0.65% | −0.06% to −0.01% |

Over placements of the code that runs, the head's cycles move by about its instructions, and every range includes
zero. Shifting the backend unit doesn't move that code, so the single executables' difference stays. Both units align
their `.text` to 64 bytes, so neither series samples a function's place within its 64-byte lines. At `cc3387f`, before
the placements (`cost-profile.sh`, `perf stat` of 5 runs each): 11.3 M more cycles (+0.58%) for 4.3 M more
instructions, the same branch misses (+0.2%), and 118 M more dispatch slots without an op from the front end (+2.0%).
Selection runs 0.76 M of the extra instructions (`select-compare.sh`: 820.73 per IR instruction by the vector path
against the new base's 817.62, and 917.54 by the scalar twin against 915.02). The samples by symbol move between
functions the change doesn't touch, which clang inlines otherwise in the checker unit, so they don't show where the
rest go.

## The corpora's programs (#141's Done-when)

At `1ea8b02` (`9700x/corpora-1ea8b02/`), every build's runs interleaved in an order rotating by round. Instructions are
`perf stat`'s user-space ones of a run.

| Program | Tier 0 | `--tier1` | `--tier1 --scalar` | clang -O0 | clang -O2 | tcc |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1, ms (11 rounds) | 256.8 | 223.5 | 220.8 | 291.0 | 131.8 | 270.9 |
| speedtest1, instructions | 5,694 M | 4,413 M | 4,431 M | 3,922 M | 2,010 M | 4,832 M |
| speedtest1, cycles | 1,331 M | 1,138 M | 1,125 M | 1,504 M | 633 M | 1,399 M |
| Lua, the five scripts, ms (sum of medians of 11 rounds) | 337.6 | 286.1 | 284.7 | 376.0 | 167.1 | 399.1 |
| Lua, instructions | 10,763 M | 8,749 M | 8,758 M | 8,329 M | 4,281 M | 9,386 M |
| Lua, cycles | 1,835 M | 1,559 M | 1,548 M | 2,062 M | 898 M | 2,187 M |
| c-testsuite's 00040, ms (5 rounds) | 25.6 | 23.6 | 24.1 | 33.2 | 12.6 | 37.9 |
| c-testsuite's 00040, instructions past startup | 886.5 M | 704.6 M | 694.1 M | 873.3 M | 373.9 M | 1,049.0 M |

So `--tier1` runs speedtest1 13% faster than Tier 0, Lua 15% and c-testsuite's one long program 8%; it is faster than
clang -O0 and tcc on all three, and takes 1.70, 1.71 and 1.87 times clang -O2's time.

Lua's scripts, ms (instructions):

| Script | Tier 0 | `--tier1` | `--tier1 --scalar` | clang -O0 | clang -O2 | tcc |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| calls | 35.2 (1,208 M) | 31.6 (1,084 M) | 31.6 (1,084 M) | 46.9 (1,015 M) | 18.6 (468 M) | 46.2 (1,131 M) |
| tables | 66.9 (2,280 M) | 56.5 (1,710 M) | 57.3 (1,713 M) | 80.6 (1,728 M) | 33.6 (782 M) | 87.0 (1,941 M) |
| strings | 63.9 (1,853 M) | 56.1 (1,430 M) | 54.9 (1,434 M) | 69.1 (1,336 M) | 36.6 (851 M) | 67.7 (1,453 M) |
| arithmetic | 72.2 (2,652 M) | 67.3 (2,451 M) | 67.6 (2,458 M) | 79.4 (2,096 M) | 32.3 (989 M) | 78.5 (2,380 M) |
| closures | 99.4 (2,770 M) | 74.6 (2,075 M) | 73.3 (2,069 M) | 100.0 (2,154 M) | 46.0 (1,191 M) | 119.7 (2,481 M) |

`--tier1` compiles 940 of Lua's 1,088 functions by Tier 1. Its interpreter loop, `luaV_execute`, is Tier 0's in both
builds (its labels as values), and takes 54% of the `--tier1` build's cycles in `tables` and 92% in `arithmetic`. By
`perf record` (`lua-profile.sh`) and each run's `perf stat` cycles, the functions Tier 1 compiles take 31% (`calls`,
`strings`) to 60% (`arithmetic`, where they are `luaV_mod` and `luaV_idiv`) fewer cycles as Tier 1's code than as Tier
0's. The code both builds leave to Tier 0 takes from 4% fewer cycles (`closures`) to 15% more (`strings`) in the
`--tier1` build than in the Tier 0 build: the same code at other addresses, by one sampled run of each.

**c-testsuite**: of the 220 programs, 18 run 10,000 or more instructions past startup by Tier 0, and 00040 (eight
queens) runs 99% of all their instructions; the others mostly run libc's `printf`. Per program, past the startup of the
empty program linked as they are, with `-lm` (`empty-lm.sh`: clang's and tcc's links load libm, buster's binds it only
where needed), the 18 programs' geometric means against Tier 0 are: `--tier1` 0.964, `--tier1 --scalar` 0.963, clang -O0
0.945, clang -O2 0.828, tcc 0.982 (`9700x/corpora-1ea8b02/summary.txt`). The other 219 programs' runs, each about 0.4 ms
of a process's start, take 84 to 103 ms a round by every build: startup, not code.

**Static instructions**, the programs' own functions (the functions clang -O0's objects define), padding left out
(`static.awk`); tcc's executables have no symbol table:

| Program | Tier 0 | `--tier1` | `--tier1 --scalar` | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| speedtest1 (2,707 functions) | 384,062 | 342,248 | 343,092 | 246,791 | 260,862 |
| Lua (1,088 functions) | 91,754 | 75,379 | 75,574 | 65,976 | 51,846 |
| Lua, the 938 functions whose code `--tier1` changes | 63,907 | 47,532 | 47,727 | 44,985 | 35,267 |
| c-testsuite, 220 programs | 15,699 | 13,224 | 13,209 | 12,815 | 10,431 |

## Selection's cycles per IR instruction

`benchmark-tier1-select-source` at `1ea8b02` on the frozen `sqlite3.c`: every function `-c` compiles, lowered, promoted
and optimized as `--tier1` takes it, outside the time; the 2,181 that both paths select, 244,036 IR instructions (204,106
typed entries), each pass planning every function; medians of 21 passes:

| Path | ns | core cycles | instructions | IPC |
| --- | ---: | ---: | ---: | ---: |
| vector, interleaved with the scalar twin | 61.02 | 338.34 | 803.93 | 2.38 |
| scalar twin, interleaved | 61.42 | 340.58 | 901.74 | 2.65 |
| vector, alone | 61.14 | 338.96 | 803.93 | 2.37 |
| scalar twin, alone | 61.38 | 340.22 | 901.74 | 2.65 |
| vector, after 200 ms of the scalar twin | 60.82 | 337.22 | 803.93 | 2.38 |

The two paths take the same time: the vector path runs 11% fewer instructions at a lower IPC.

**Where it goes.** `tier1_select_plan` verifies its input first (`ir_verify`, or `ir_verify_scalar` on the scalar path),
though the pipeline verified the same IR after optimizing it. `verify-experiment.sh` times the verification alone on the
same functions and dominance: 86.43 cycles per IR instruction by `ir_verify` and 81.35 by `ir_verify_scalar`
(interleaved; alone 85.76 and 80.66), a quarter of each path's selection; the vector verifier is the slower. Of the
rest, `perf record` (`select-profile.sh`) puts most in `tier1_select_plan` itself, into which the labeling, the cover
and the patterns inline (37% of the process's cycles, the corpus's preparation included), and 3.6% in
`tier1_select_address`, the address walk.

## Limitations

- The `--tier1` builds are both tiers' code: Tier 1 compiles 2,181 of speedtest1's sqlite3.c functions and 940 of
  Lua's, and the hottest function of each, `sqlite3VdbeExec` and `luaV_execute`, stays Tier 0's. The run times measure
  Tier 1's code where it compiles, not a Tier 1 build.
- c-testsuite's programs are short: past 00040, their runs measure process startup.
- The cycles by tier come from one sampled run of each build and script, with functions classed by whether their code
  differs between the Tier 0 and `--tier1` builds.
- The `--tier1` builds have no unwind tables, the others do.
- The mutants and the math check ran on this session's container, not the 9700X; their results are failure counts, not
  timings.
