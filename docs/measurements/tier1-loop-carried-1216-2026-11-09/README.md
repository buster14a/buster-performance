# Tier 1: dispatch loops keep loop-carried values in registers (#1216), 2026-11-09

Evidence for [buster#1216](https://github.com/buster14a/buster/issues/1216): the branch
`droid/1216-loop-carried-registers` at `540ace7ef0762e6061ae567a5c445e03cf4bb373` (**head**) against its merge base
with main, `6a021550eefa2bc4a6b2db2ac06d661c06d137f9` (**base**). The issue asks for the dynamic edge spills, reloads
and moves (tags `T`, `U` and `e`, #1189's method) on speedtest1 and Lua's five scripts to be at least halved, and for
the runtime to be measured on the 9700X.

**Both targets are met, and both programs run faster on the 9700X.**

| Tagged edge traffic, T+U+e (callgrind) | base | head | change |
| --- | ---: | ---: | ---: |
| speedtest1 | 469.1 M | 225.7 M | -51.9% |
| Lua 5.4.8, five scripts | 1,012.7 M | 476.8 M | -52.9% |

| 9700X, CPU 2 | base | head | 100 ln(head / base), 95% interval |
| --- | ---: | ---: | ---: |
| speedtest1, user cycles (median over 8 shifts) | 974.4 M | 928.3 M | -4.91 (-5.54 to -4.27) |
| speedtest1, task-clock | 193.1 ms | 184.9 ms | -4.51 (-5.05 to -3.97) |
| Lua's five scripts, user cycles (median over 33 link orders) | 1,321.5 M | 1,218.8 M | -8.25 (-8.68 to -7.81) |
| Lua's five scripts, task-clock | 242.1 ms | 222.9 ms | -8.41 (-8.83 to -7.98) |

Head is faster at every layout: 33 of 33 Lua link orders and 8 of 8 speedtest1 shifts. The intervals are over the
independent layouts (section 2). User instructions fell 8.74% on speedtest1 and 13.72% on Lua, matching callgrind's
program counts (-8.7% and -13.9%).

## 1. Tagged edge traffic (callgrind)

These counts ran on the owner's desktop, **not the 9700X**: AMD Ryzen 9 7940HS, Linux 7.3.3-1-cachyos, valgrind
3.25.1, GNU objdump 2.47, clang 23.1.4 (the compilers' build). Instruction counts are not times.

- **Compilers.** `scripts/kinds.sh REV NAME` makes a clean worktree of REV, applies
  `patches/kinds-instrumentation-NAME.patch` and builds it with `BUSTER_DEBUG_INFO=0` and
  `BUSTER_BUILD_DEFINES=-DBUSTER_TIER1_MEASURE_KINDS=1`. The patch is the `kinds.patch` of
  [dispatch-1736-95fb-integration-2026-11-08](../dispatch-1736-95fb-integration-2026-11-08/README.md)'s `raw.tar.gz`
  (the same added and removed lines; the two files here differ from it and from each other only in `index` lines and
  hunk offsets). It carries
  [#1189's tags](../tier1-gap-1189-2026-11-03/README.md) (`tools/kinds-experiment.diff` there) to current main, behind
  that define: with `BUSTER_TIER1_KINDS=FILE`, each function Tier 1 compiles gets a line of tags in FILE. `T` and `U`
  are a spill and a reload on a CFG edge, `e` an edge move; the record gives the others. `tagged/compilers.sha256`
  has the two compilers' hashes.
- **Programs and counts.** `scripts/m.sh COMPILER OUT` builds speedtest1 (#136's `speedtest1-unity.c`, in `inputs/`:
  SQLite 3.53.2's amalgamation, then its `test/speedtest1.c`, with #136's flags) and Lua 5.4.8 (its 33 sources) by
  `--tier1 -fno-asynchronous-unwind-tables --tier1-report`, checks speedtest1's `--verify` hash and each script's
  output against clang -O0's, runs each under callgrind (through
  a generic x86-64 glibc 2.44 loader, since the host's glibc is built with instructions valgrind can't run) and joins
  the counts with the tags by #1189's `tools/gap.c` (byte for byte that record's). `scripts/ana.sh` and
  `scripts/show.sh` break a function's counts down by instruction.
- **Files.** `tagged/base` and `tagged/head`: `summary.txt` (the totals below), `runs.txt` (each run's whole-process
  count and `gap`'s unmatched check: 0 for every run), `report-*.txt` (the `--tier1-report` totals: 2,709 functions of
  speedtest1 and 1,088 of Lua compiled, no fallbacks), `verify.txt`, the scripts' outputs, `inputs.sha256` (the
  executables, disassemblies and tag files) and `data.tar.zst` (the tag files, build reports, callgrind outputs and
  `gap`'s TSVs).

| Tagged instructions | base | head | change |
| --- | ---: | ---: | ---: |
| speedtest1 T+U+e | 469,106,077 | 225,743,710 | -51.9% |
| of which `sqlite3VdbeExec` | 253,868,126 | 114,844,405 | -54.8% |
| speedtest1 program instructions | 3,351,065,435 | 3,058,632,714 | -8.7% |
| Lua (five scripts) T+U+e | 1,012,746,378 | 476,782,044 | -52.9% |
| of which `luaV_execute` | 937,955,673 | 415,689,120 | -55.7% |
| Lua program instructions | 6,285,584,279 | 5,413,877,609 | -13.9% |

By tag, speedtest1's T, U and e went from 151.1M, 163.6M and 154.4M to 60.8M, 77.1M and 87.9M; Lua's from 374.6M,
370.7M and 267.4M to 33.3M, 52.5M and 390.9M. Lua's edge moves rose as its edge stores and reloads fell: values that
crossed `luaV_execute`'s edges through their slots now cross them in registers, where a mismatch costs a move rather
than a store and a reload.

Reproduction: an earlier build of each revision from the session's working tree (the same patch, with a local
stderr-only diagnostic, `BUSTER_TIER1_DEBUG_DISPATCH`, compiled in) gave identical T and U, identical speedtest1 e,
and Lua e within 8,712 of 267M. Program totals of Lua move by a few million between runs because Lua seeds its string
hash from addresses. The 95fb record's base, `95fb03f06`, measured on the 9700X under callgrind 3.25.1, gave
speedtest1 T, U and e of 151,079,195, 163,581,243 and 154,445,926.

The timed objects below are the counted code: each of the 34 objects (33 of Lua, speedtest1's one) that the 9700X's
plain `znver5` compilers built has the same `.text` bytes as the tagged compilers' (`9700x/text-*.txt`).

## 2. Runtime on the 9700X

- **Machine.** Ryzen 7 9700X, Linux 6.18.50-2-lts, CPU 2 (`performance` governor, its SMT sibling, CPU 10,
  offline), glibc 2.44, GCC 16.2.1 and GNU ld 2.47 (`cc`, the link), perf 7.2.9, clang 23.1.1 (the compilers' build).
- **Lock.** Every build, compile, link, check and timed run took its own hold of `exclusive.sh`; other sessions' and
  CI's work ran between them.
- **Compilers** (`scripts/compilers.sh`): each revision's own `build.sh`, `BUSTER_HOST_ARCH=znver5`
  (`9700x/build.log` has their hashes).
- **Executables** (`scripts/prepare.sh`): each compiler builds Lua's 33 objects and speedtest1's one object once,
  with the flags above (`9700x/objects-*.sha256`, `9700x/reports-*.txt`). Lua is linked by `cc` in 33 orders, the
  same for both revisions: order 0 the usual one, the others `shuf`'s seeded by the order's number, as #1435's
  `orders.sh` made them. They are the 33 orders of
  [closures-stli-1435-2026-11-05](../closures-stli-1435-2026-11-05/README.md)'s `orders2` (`9700x/orders.txt`).
  speedtest1 is one object, which can only move as a whole (the driver refuses `-ffunction-sections`), so its
  placements are shifts: linked after a padding object of 0, 528, ..., 3,696 bytes (multiples of its `.text`
  alignment, 16, spread over a page). **Its shifts move all of its code together; they don't change the code's
  relative layout,** which only a compiler change does. `9700x/addresses.txt` has the hot functions' addresses in
  every executable.
- **Checks.** Before any timing, all 82 executables passed: every Lua order printed clang -O0's output for all five
  scripts and every speedtest1 shift gave the hash `1248168 a7fa3957…` (`9700x/checks.txt`).
- **Runs** (`scripts/time.sh`): every executable once untimed (each script for Lua), then 5 rounds of Lua (each of
  the 33 orders, each script, both revisions) and 7 rounds of speedtest1 (each of the 8 shifts, both revisions), the
  programs' rounds interleaved. Each run is pinned to CPU 2 and counted by `perf stat` (task-clock, user cycles and
  instructions). The two revisions run
  back to back for each layout and script, in an order alternating by round, layout and script. speedtest1 runs from
  a fresh database and temporary directory on tmpfs, made and removed outside its count, with
  `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`.
- **Statistics** (`scripts/analyze.c`, `cc -O2 -o analyze analyze.c -lm`): the median of each cell's runs (layout,
  revision, script); a Lua layout's total is the sum of its scripts' medians. The comparison is each layout's
  `100 ln(head / base)`, its mean over the independent layouts with a 95% t interval, its median, spread and sign
  count. `9700x/analysis.txt` is its output.

### Results

1,762 timed runs, all exiting 0 with every count: 5 per Lua cell (330 cells) and 7 per speedtest1 cell (16). The
warm-ups waited for other sessions' and CI's holds of the lock (00:18 to 00:36 UTC); the timed runs took 00:36:40
to 00:38:35 (`9700x/log.txt`).

**Lua**, the sum of the five scripts' medians, over the 33 link orders:

| Metric | base, median over orders (range) | head | 100 ln(head / base): mean, 95% t interval | sd over orders | head slower at |
| --- | ---: | ---: | ---: | ---: | ---: |
| user cycles | 1,321.5 M (1,304.2 to 1,373.0) | 1,218.8 M (1,204.4 to 1,245.1) | -8.25 (-8.68 to -7.81) | 1.24 | 0 of 33 |
| task-clock | 242.14 ms | 222.89 ms | -8.41 (-8.83 to -7.98) | 1.19 | 0 of 33 |
| user instructions | 6,818.4 M | 5,944.9 M | -13.72 (-13.74 to -13.70) | 0.05 | 0 of 33 |

By script, user cycles: calls -17.03 (-18.05 to -16.00), arithmetic -14.98 (-15.54 to -14.42), closures -6.83
(-8.09 to -5.58; head slower at 2 of 33 orders), tables -6.19 (-6.58 to -5.81), strings -1.39 (-1.96 to -0.81;
head slower at 7 of 33). The usual order (0) is base's slowest, 1,373.0 M, where head gains 12.15; the smallest gain
is 5.12, at order 22.

**speedtest1**, over the 8 shifts:

| Metric | base, median over shifts (range) | head | 100 ln(head / base): mean, 95% t interval | sd over shifts | head slower at |
| --- | ---: | ---: | ---: | ---: | ---: |
| user cycles | 974.4 M (968.0 to 985.1) | 928.3 M (925.2 to 931.6) | -4.91 (-5.54 to -4.27) | 0.76 | 0 of 8 |
| task-clock | 193.09 ms | 184.87 ms | -4.51 (-5.05 to -3.97) | 0.64 | 0 of 8 |
| user instructions | 3,479.5 M | 3,188.3 M | -8.74 | 0.00 | 0 of 8 |

**Run to run.** The median cell's runs vary by 0.57% (Lua) and 0.19% (speedtest1) in cycles. 27 of Lua's 330 cells
vary by over 2%, 24 of them base's. Most hold one slow run, up to 48% over its cell's others (order 25, base,
`strings.lua`); a few of base's `calls.lua` cells alternate between about 154 M and 160 to 166 M cycles. The cells'
medians leave the single slow runs out.

### Limits

- speedtest1's shifts move its one object as a whole, so its interval covers placement against pages and lines, not
  the relative layout of its functions. Lua's 33 orders do vary that.
- The interval is over the layouts' paired ratios, the layouts taken as independent samples; a layout's runs only
  make its medians and add no samples.
- These are base and head of this branch only; main has moved since 6a021550e, without changes to Tier 1's files.

## Files

- `scripts/`: `kinds.sh`, `m.sh`, `ana.sh`, `show.sh` (tagged counts); `compilers.sh`, `prepare.sh`, `time.sh`,
  `analyze.c` (the 9700X).
- `patches/`: the instrumentation for each revision.
- `inputs/`: the unity file and the inputs' hashes.
- `tagged/`: section 1's data.
- `9700x/`: section 2's logs, orders, checks, hashes, addresses, reports and `runs.txt` (a line per run: program,
  layout, round, revision, script, exit status and counts), `log.txt` and `analysis.txt`.

The inputs are external and not included, but for `inputs/speedtest1-unity.c`: SQLite 3.53.2's amalgamation
(`sqlite3.c`) and `speedtest1.c`, the hashes the
[frozen dispatch record](../dispatch-1736-frozen-2026-11-08/README.md) gives, Lua 5.4.8 and the five scripts of the
`cc3387f` record. `inputs/inputs.sha256` has their hashes and clang -O0's outputs', and `inputs/lua-5.4.8.sha256`
each of Lua's files'. The instruction text in `gap`'s TSVs and the function names in the callgrind outputs inside
`tagged/*/data.tar.zst` derive from public-domain SQLite and from Lua 5.4.8 (MIT, Copyright (C) 1994-2025 Lua.org,
PUC-Rio).
