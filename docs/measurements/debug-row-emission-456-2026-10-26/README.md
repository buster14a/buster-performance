# What `-g` adds to the emission (#456), 2026-10-26

[buster14a/buster#456](https://github.com/buster14a/buster/issues/456) asked why `benchmark-check-debug`'s emission
with the raw rows went from +1.1% over the emission without them (at `1771a6ea`, #426's head before its second unit was
removed) to +4.3% (at `b5a4e863`, #426's final head), where that cost goes, and whether to reduce it or accept it.

In short:

- On the 9700X, `-g` adds 4.4 to 4.8% to the emission at main (`3b025c73`) and 5.5% at `b5a4e863`: 0.26 ms on 6.05,
  and 6.24 million of its 132.2 million user instructions. The prior head's +1.0% reproduces too.
- Nine tenths of it is the lowering's copy that keeps each entry's token: 5.61 million instructions, about 28 for
  each of the 197,000 tasks the lowering pops. The raw rows take 0.54 million (8.6%), Tier 0's entries' first
  records 0.10 million (1.5%), and their room nothing measurable. With only that lowering left out, the emission
  with the rows takes as long as the one without.
- The +1.1% measured something else: the prior design's benchmark ran in the `-g` unit, whose lowering kept the token
  with every push and set it at every pop whether or not it wrote rows (`BUSTER_CHECK_SOURCE_ROWS`); only the store of
  each entry's token depended on the rows. Its emission without the rows retired 2.3 million more instructions than
  main's plain one, and its rows 1.1 million more on top. The whole compile shows the same move in #426's own record:
  `-g` added 20.2 million instructions at rows6 (two units) and 25.3 million at rows10 (one unit).
- Of five cheaper forms of the same bookkeeping, one retired fewer instructions (0.33 million, 5% of the overhead),
  and on the 9700X its emission with the rows took as long as main's while its emission without them, the plain
  lowering's code unchanged, took 0.8% longer: where the code lands moved more than the work did. The others retired
  more. The trade-off is kept: the plain lowering, which every compile without `-g` runs, does none of this work, and
  its code is #426's.

## Trees

| Name | Source | What it is |
| --- | --- | --- |
| `main` | `3b025c73` | main when the work began, #426 merged (`1e7824c1`) |
| `head426` | `b5a4e863` | #426's final head, the issue's "+4.3%" |
| `prior426` | `1771a6ea` | #426's head with `-g` in a unit of its own, the issue's "+1.1%" |
| `screen` | `3b025c73` and `variants/screen-switches.py` | main with switches for the attribution, chosen by `BUSTER_456_VARIANT` |
| `vM` | `3b025c73` and `variants/vM.patch` | main with the settle's columns and bounds read once, its loops neither vectorized nor unrolled |

Each tree was sent by tar from its commit's `git archive` (with the patch applied for `screen` and `vM`);
`source-*.sha256` holds the SHA-256 of each of its files, and `binaries.sha256` the executables'. Each built with
`BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`, as the 9700X job builds (`build-*.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each
round of measurements took the shared lock on its own, through `~/buster-fast-bench/exclusive.sh` with
`EXCLUSIVE_OWNER=claude-perf-456`. The lock's waiting messages, which name other runs, are removed from the logs;
nothing else in them is changed.

## Method

The workload is `benchmark-check-debug --only emit`'s: the program its generator makes from seed 395, 2,000
functions with 101,493 typed entries and 60,031 raw rows (every tree printed the same counts), compiled once outside
the timing. A sample is one `check_program_emit` of it by the vector path, with its arenas put back after, either
without the raw rows or with them; the benchmark warms each up once, then takes `--runs` samples of each, the two
taking turns, and reports their medians.

- Times (`emit.sh`, `round.sh`): `taskset -c 2 ./build/compiler benchmark-check-debug --only emit --runs 101` in each
  tree, a process per tree (and per screening variant), every one of them once per round in an order that rotates by
  round, five rounds, one hold of the lock per round. `emit.log` has the eight cases of the attribution, `emit-vM.log`
  main and `vM`. A process's change is its two medians' ratio; the tables give the median of the five rounds' changes,
  and their range.
- Instructions (`counts.sh`, `counts-round.sh`): `perf stat -x, -e instructions:u,cycles:u taskset -c 2 ./build/compiler
  benchmark-check-debug --only emit --path scalar|vector --runs 10|30`: `--path scalar` times only the emission without
  the rows and `--path vector` only the one with them, and the difference between `--runs 30` and `--runs 10`, over
  20, is one emission (the setup and the warm-ups cancel). User instructions repeat to within a few hundred; the cycles
  of the whole process don't give a usable difference, and the times above stand for them.
- The attribution's variants (`variants/screen-switches.py`, bits of `BUSTER_456_VARIANT`, set by the benchmark after
  its setup and applied only to the emission with the rows): 1 leaves out the per-function rows
  (`check_program_emit_body_rows`), 2 Tier 0's entries' first records (`Tier0Function.entry_records`), 4 the
  lowering's copy that keeps the tokens (`check_program_lower_sources`, for `check_program_lower`), 8 the rows' room
  (`check_program_emit_reserve_rows`). The cases are cumulative: 0, 1, 3, 7 and 15.

`laptop-counts.md` has the same counts on a Ryzen 9 7940HS, every variant tried, and where the lowering's copy spends
its instructions.

## Results

### The overhead

| Tree | Without the rows | With them | Change, median (range) |
| --- | ---: | ---: | ---: |
| `main` (`emit.log`) | 6.055 ms | 6.318 ms | +4.76% (+4.33 to +5.09) |
| `main` (`emit-vM.log`) | 6.023 ms | 6.303 ms | +4.41% (+4.39 to +4.65) |
| `head426` | 5.993 ms | 6.295 ms | +5.45% (+5.04 to +5.74) |
| `prior426` | 6.084 ms | 6.152 ms | +1.02% (+0.94 to +1.25) |

| Instructions per emission | Without the rows | With them | Change |
| --- | ---: | ---: | ---: |
| `main` | 132,152,188 | 138,391,340 | +6,239,152 (+4.72%) |
| `head426` | 132,152,133 | 138,391,404 | +6,239,271 (+4.72%) |
| `prior426` | 134,463,097 | 135,559,724 | +1,096,627 (+0.82%) |

`head426` and `main` run the same lowering and emission (the commits between them change neither), and their
emissions retire the same instructions; their times differ by where the code lands.

### Where it goes

| Screening variant | Change, median (range) | Instructions added per emission |
| --- | ---: | ---: |
| 0: everything | +5.47% (+5.29 to +5.77) | 6,247,347 |
| 1: without the per-function rows | +5.32% (+4.73 to +6.12) | 5,708,042 |
| 3: nor Tier 0's entry records | +5.16% (+4.98 to +5.26) | 5,612,830 |
| 7: nor the lowering that keeps the tokens | +0.00% (-0.22 to +0.50) | 49 |
| 15: nor the rows' room | -0.12% (-0.48 to +0.12) | -148 |

So the lowering's copy that keeps the tokens is 5,612,781 instructions (89.8%) and the time with them; the
per-function rows 539,305 (8.6%), Tier 0's entry records 95,212 (1.5%), and the rows' room none. In the time, each of
the last three is within the rounds' spread.

The lowering keeps the tokens lazily (#426, `check_lower_settle`): no entry or push, in the helpers the plain
lowering shares, spends anything on them, and each pop of a task settles the entries written and the tasks pushed
since the pop before, picks the popped task's token (its expression's, its statement's, or the one it was pushed
under) and keeps it. The program's lowering pops 197,144 tasks; 5.61 million instructions is 28.5 per pop.

### Why the prior head measured +1.1%

At `1771a6ea` the benchmark ran in `main_unit_debug.c`'s unit, in which `BUSTER_CHECK_SOURCE_ROWS` is 1: there the
lowering saved the token in every task it pushed and set it from every task it popped, rows or none, and only the
store of each entry's token tested whether the emission wanted rows. Both of its emissions kept the tokens; the
change compared the per-entry store and the rows with nothing. Its emission without the rows retired 134.46 million
instructions, 2.31 million more than main's plain one, which is every compile's without `-g` (the bases differ by
#426's other changes and main's between them, so that difference is an upper bound of the tracking's share).

### What was tried, and why none is kept

| Variant (`variants/`) | Instructions added with the rows (laptop) |
| --- | ---: |
| main | 6,239,259 |
| v1: the settle from local copies, the bookkeeping before the pop, the token columns read once per drain | 8,177,696 |
| v2: v1, the settle's loops not vectorized | 8,634,430 |
| v3: v2, nor unrolled | 6,992,785 |
| vM: main, the settle from local copies, its loops neither vectorized nor unrolled | 5,909,884 |
| vN: vM, the bookkeeping out of line, before the pop | 7,133,187 |

- Read through the writer, the settle's columns and bounds could change with every store, and clang read them
  again for each entry and task. From local copies, clang vectorized and unrolled the loops, which a settle of zero
  to two items only slows; with both off (vM) they cost 0.33 million instructions less.
- Doing the bookkeeping before the pop (v3) lets the loop read the task's fields after the stores, where it uses them,
  as the plain loop does (a store through the writer could change the task), and saves about 8 instructions per pop
  in its own code, but clang allocated the rest of the 17 KB loop's registers worse (`laptop-counts.md` has the IBS
  samples): 0.75 million more in all. Out of line (vN), the call and the reloads cost 0.89 million more.
- vM on the 9700X (`emit-vM.log`): its emission with the rows took 6.302 ms against main's 6.303, and its emission
  without them 6.070 against 6.023 ms (+0.8%), the plain lowering's code the same as main's: its `-g` copy's smaller
  code moved what follows it, the plain loop among it. Its +3.80% against main's +4.41% is that, not a faster `-g`.

The bookkeeping of the lazy tokens is about 25 to 30 instructions per pop in every form tried. What would remove it
is the eager form, a store with every entry and every push, in helpers the plain lowering shares: either it pays for
them too (0.96 million instructions at #426's `739b4b4`, where those helpers tested the flag), or they are compiled
twice (the second unit cost 10.5% of the build's CPU time). Neither is worth 0.26 ms of a `-g` compile of 51.9 ms
(rows10).

## Files

- `builds.sh`, `builds.log`, `build-*.log`: the builds.
- `emit.sh`, `round.sh`, `emit.log`, `emit-vM.log`: the times.
- `counts.sh`, `counts-round.sh`, `counts.log`: the instructions.
- `chain1.sh`: the queue that ran `vM`'s build, its rounds and the counts after the first rounds.
- `variants/`: the screening switches and the patches tried.
- `laptop-counts.md`: the laptop's counts, the pops and the IBS samples.
- `source-*.sha256`, `binaries.sha256`: the identities.

## Limitations

The program is the benchmark's generated one; the lowering's pops per entry depend on the code (here 1.94). The
times are one benchmark process's medians of 101 samples each, five processes per tree; the change between two
processes of one tree varied by up to 0.8 points. The laptop's and the 9700X's builds differ in `-march=native`
(znver4 and znver5), which moves the counts by 0.2%. No whole compile was measured again: #426's record (rows10) has
`-g`'s whole-compile cost at the code these trees run.
