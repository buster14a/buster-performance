# The executable's own pages: the start order from traces, and huge pages (2026-11-16)

Evidence for [buster#2873](https://github.com/buster14a/buster/issues/2873), the first piece of the kernel row's
allocation after the census ([`kernel-census-2873-2026-11-16`](../kernel-census-2873-2026-11-16/README.md),
[`kernel-census-musl-2873-2026-11-16`](../kernel-census-musl-2873-2026-11-16/README.md)): what a process pays to map
its own executable, and to unmap it again at its exit. The change is buster's pull request for the piece (branch
`claude/compassionate-meitner-onzlwq`): `compiler start-trace`, the start order made from its traces, the link placed
for huge pages, and the exit helper's probe and look.

- **Source:** buster main `1c6cc8ab5e778ab32078cbef17049c4814b30dca`, and three patches on it, which are the pull
  request's diff by its files (`scripts/build-tree.sh`): the tracer (`profile.c`, `profile_test.c`, `main.c`), the list
  (`cmake/BusterStartOrder.txt`), and the link and the helper (`CMakeLists.txt`, `cmake/BusterStartOrder.cmake`,
  `lane.c`, `lane_test.c`). `order` is main with the tracer and the list; `full` is main with all three. Each tree is a
  clone built on the host by `./build.sh --config Release` in one hold of the lock. SHA-256 of the executables
  (`raw/build-*.out`): main `b6f055c1…`, `order` `589f37a4…`, `full` `63045aa6…` (the pull request's head: section
  "The head"), `full` before the head's last test `29a46a0a…`, the first version's `full` `8a1f3f63…`.
- **Host and runs:** as the census. The 9700X, Linux 6.18.50, transparent huge pages `always`, btrfs. Every run is one
  hold of the lock (`scripts/lock.sh`, `raw/holds.txt`), the compiles on CPU 2 and perf on CPU 4.
- **Workloads:** the census's (`sqlite3.c`'s `-c`, 716,136 tokens; the frozen corpus's musl, 1,336 units and 5,039,639
  tokens, a process a unit and as one command on one lane) and the four small commands of
  [`checker-start-order-1444-2026-11-14`](../checker-start-order-1444-2026-11-14/README.md) (an empty file's
  `-fsyntax-only` and `-E -P`, `tiny.c`'s `-c`, `hello.c`'s `-c`; `scripts/inputs`), 100 runs a count.
- **An A/B** (`scripts/ab.sh`): each side from a fresh copy of its executable (`cp`, a reflink: none of it is in the
  page cache until it runs), warm-up runs, then rounds in ABBA order. Every compile runs under `waitall`, which waits
  for the exit helper, and is counted on CPU 2 as a whole (`perf stat -C 2`: kernel and user cycles, user
  instructions, page faults, instruction TLB misses), so the counts hold the exit's teardown and the helper, as the
  census's did, and the harness's own processes, the same on both sides. `scripts/tools/abstat.c` makes the tables:
  each side's median, the median of the rounds' paired differences with its quartiles, and the rounds in which B was
  lower. `tables/` has every one, with each copy's state in the page cache after the warm-ups and at the end
  (`scripts/tools/collapse.c`'s `check`).

## In short

- **The start order alone** (the functions that real compiles run, placed together; the page cache in 4 KB pages):
  musl a unit a process takes 38 fewer faults a unit, 4.6% fewer kernel cycles and 1.1% fewer user cycles;
  `sqlite3.c`'s `-c` 45 fewer faults and 1.5 M fewer kernel cycles (17 of 21 rounds); the small commands 2.2% to 3.8%
  fewer kernel cycles.
- **With the executable in huge pages** (the pull request's head against main):

  | | kernel cycles | paired | user cycles | paired | page faults |
  | --- | ---: | ---: | ---: | ---: | ---: |
  | `-c sqlite3.c`, 21 rounds | 86.18 → 83.99 M | −2.30 M (−2.67%), 21 of 21 | 595.9 → 592.9 M | −3.08 M (−0.52%), 19 of 21 | 5,899 → 5,763 |
  | musl, a unit a process, 5 rounds | 6,239.0 → 5,439.4 M | −797.4 M (−12.78%), 5 of 5 | 5,265.3 → 5,070.9 M | −191.6 M (−3.64%), 5 of 5 | 906,362 → 752,195 |
  | musl as one command, 5 rounds | 995.9 → 995.4 M | −0.5 M (−0.05%), 3 of 5 | 2,826.4 → 2,793.8 M | −29.5 M (−1.04%), 5 of 5 | 275,776 → 275,634 |
  | an empty file's `-fsyntax-only` ×100, 11 rounds | 230.1 → 204.6 M | −10.59%, 11 of 11 | 62.5 → 58.8 M | −6.44% | 33,211 → 28,307 |
  | an empty file's `-E -P` ×100 | 186.1 → 169.8 M | −8.13%, 11 of 11 | 48.5 → 46.4 M | −4.82% | 25,315 → 22,714 |
  | `tiny.c`'s `-c` ×100 | 287.9 → 244.6 M | −14.52%, 11 of 11 | 86.7 → 80.0 M | −7.72% | 40,211 → 32,700 |
  | `hello.c`'s `-c` ×100 | 421.4 → 376.7 M | −10.80%, 11 of 11 | 368.9 → 358.1 M | −3.05% | 62,389 → 53,381 |

  The objects are the same bytes (`sqlite3.c`'s in 21 rounds of 21, the one command's 1,336 in 5 of 5).
- **By the token:** musl a unit a process, 158 kernel cycles and 38 user cycles a token less (the census's row for the
  executable's pages was 123 after the start and 33 of the start's 99); `sqlite3.c`, 3.2 kernel cycles and 4.3 user
  cycles a token less (the census's row: 2.5 after the start).
- **The probe is free where the executable is in huge pages:** a process reads one byte between two readings of the
  time-stamp counter, 42 instructions with its test, and no kernel cycle measured (0.04% apart from the same
  executable with the look off, 15 rounds on one copy). A probe that asked the kernel in the helper, the first
  version's, read 4,900 kernel cycles a process.
- **A new executable** is in huge pages after its second run (a copy written rather than reflinked: after its third),
  for 7 M to 13 M kernel cycles of its helpers' over those runs.
- **What the executable still takes** is its data: of `-c sqlite3.c`'s 80 faults in it (216 on main), 20 are in
  `.data.rel.ro`, 21 in the baked tables and 22 in `.bss`.
- **Memory:** a process's resident set counts a huge page whole. `-c sqlite3.c`'s peak reads 241,656 KB against
  235,780, an empty file's `-c` 13,780 KB against 8,004 (`tables/peak-*.txt`, 11 rounds each). The pages are the page
  cache's, 12 MB of the executable.

## 1. The start order from traces

`compiler start-trace OUTPUT COMMAND...` runs a command with a breakpoint at the entry of every function of its
executable, each removed as it is reached, and appends the addresses of the functions the command ran.
`scripts/order.sh` traces the four small commands, each of musl's 1,336 units' `-c` (a process each, one file of 1,336
traces) and `sqlite3.c`'s `-c`, with the tree's own executable, and `compiler start-order` writes the list from them:
the small commands' functions by the smallest command that ran each, then musl's by how many units ran each, then what
`sqlite3.c` adds. `raw/start-order-inputs.tar.xz` holds the inputs of the list as merged: the executable's `readelf
-sW`, the six trace files, the counts and the list's body (`full0`'s, SHA-256 `3e5d26a5…`: the three patches with the
list before it, built as the benchmark builds are, `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`).

- 1,013,393 addresses in 1,341 traces, none outside a function. The list has 1,432 functions: 1,153 of `main.c`'s
  units (4,162 KB) and 279 by name, the C library's (184 KB).
- An earlier pass on main `56c2c294` (`results/trace` in `raw/v1.tar.xz`, a prototype tracer, `scripts/tools/starttrace.c`;
  `scripts/simulate.py`): `-c sqlite3.c` runs 1,161 functions (3.66 MB) in 120 of `.text`'s 64 KB windows, 57 if
  packed; 415 functions run in every unit of musl's; a unit's functions are in 98 windows at the mean, 58 if ordered
  so.
- perf's samples, which made the list before (`perf record -b -e instructions:u`, a period a process), lacked 86 to 111
  of the functions that a trace of each small command finds, and named 35 that no small command's trace enters, on a
  tree two days newer.

Main against `order`, the list alone (`tables/ab-order-*.txt`; the page cache holds no huge page of either):

| | kernel cycles, paired | rounds lower | user cycles, paired | page faults | iTLB misses |
| --- | ---: | ---: | ---: | ---: | ---: |
| `-c sqlite3.c` | −1.48 M (−1.71%) | 17 of 21 | −0.19% | 5,899 → 5,854 | −5.9% |
| musl, a unit a process | −287.1 M (−4.59%) | 5 of 5 | −1.13% | 907,743 → 856,633 | −7.4% |
| musl as one command | −6.9 M (−0.69%) | 4 of 5 | −0.28% | 275,775 → 275,730 | −8.5% |
| `-fsyntax-only` ×100 | −3.21% | 11 of 11 | −3.22% | 33,204 → 31,810 | −8.7% |
| `-E -P` ×100 | −2.24% | 8 of 11 | −2.45% | 25,304 → 24,514 | −9.5% |
| `tiny.c` ×100 | −3.84% | 10 of 11 | +0.47% (5 of 11) | 40,212 → 38,815 | −7.7% |
| `hello.c` ×100 | −2.79% | 11 of 11 | −0.59% (6 of 11) | 62,383 → 60,478 | −5.3% |

## 2. The executable in huge pages

- **The link.** Main's text is loaded a page off its place in the file (`0xd53fd0` in memory, `0xb52fd0` in the file:
  apart by `0x201000`), so no 2 MB range of it can be mapped by a huge page. With `-z max-page-size=0x200000` every
  segment is a multiple of 2 MB from its bytes in the file, and the start order's script starts `.text.buster_start`
  at `0x1000000`. The file is 0.8 MB longer.
- **The ranges.** The read-only data has 5 whole 2 MB ranges and the code 18. The helper's look asks for the 4 that
  hold the code the start order places (to `buster_start_end`, `0x1710b35`) and for each other range in which the
  process mapped 64 pages or more: 2 of the read-only data's for these compiles. That is 12 MB of the file's 68 MB of
  segments.
  A sampled process's look (one in 64) and `khugepaged` (the host's `max_ptes_none` is 511) add a range now and then:
  a copy's state is in each table.
- **The faults in the executable,** one process of each (`scripts/residual.sh`, `scripts/tools/faultsec.c`,
  `tables/residual-*.txt`), `-c sqlite3.c`:

  | section | main | `order` | `full` |
  | --- | ---: | ---: | ---: |
  | `.sframe`, `.rodata` | 1, 29 | 1, 29 | 1, 6 |
  | `.text.buster_start`, `.text.buster_checker`, `.text`, `.iplt` | 12, 73, 36, 0 | 21, 45, 7, 1 | 1, 2, 1, 1 |
  | `.data.rel.ro`, `.relro_padding`, `.data` | 18, 1, 1 | 18, 1, 1 | 20, 1, 3 |
  | `buster_baked`, `.got.plt`, `.bss` | 22, 1, 22 | 23, 1, 22 | 21, 1, 22 |
  | all of the executable | 216 | 170 | 80 |

  A fault of a huge page's range maps all of it: the code's four ranges take 4 faults where main took 121.

## 3. The probe

The helper must not look each time: a look opens `/proc/self/pagemap`, whose entries the kernel makes for each new
process. The first build's helper, which looked each time, read about 40,000 kernel cycles a process against the same
executable with the look off (53.9 M of a pass of musl's units, 5 rounds of 5: `tables/v1/each-look-musl.txt`). So the
link leaves the first 128 KB of the placed code empty, two windows of the kernel's fault-around, which no fault of a
process's own maps: a page of them is mapped only where a huge page maps the range.

- **The first version** (`raw/v1.tar.xz`, `tables/v1`) asked the kernel in the helper, once the caller had gone: `move_pages`
  as a query of the first window's page.
- **The head** reads a byte of the first window in the exiting process, between two readings of the time-stamp
  counter: fewer than 128 ticks says no fault happened. On the 9700X a mapped page's read takes 1 tick (the second
  reading doesn't wait for the read), and one that faults about 3,000 (`test-lanes`, `raw/results/tests-head.d/1.txt`).
  A slower read is settled by the kernel's answer for a page of the second window. Where the page is mapped the process
  makes no system call for it, and its helper is main's.

| the look on against off, one copy (`scripts/same.sh`, `ab.sh`'s `SAME`) | kernel cycles, off less on | rounds lower off | user instructions a process |
| --- | ---: | ---: | ---: |
| the head, musl a unit a process, 15 rounds | +2.1 M of 5,426 M (+0.04%) [−11.3, +7.1] | 6 of 15 | 42 |
| the head, `-fsyntax-only` ×100, 31 rounds | +1.4 M of 206.1 M [−1.7, +4.3] | 12 of 31 | 47 |
| the first version, musl a unit a process, 15 rounds | −6.5 M of 5,435 M (−0.12%) [−21.2, −0.4] | 11 of 15 | 381 |

The first version against the head, a copy each, both with their six ranges in huge pages (`tables/v1-musl.txt`, 9
rounds): kernel cycles −2.5 M (−0.05%) [−7.9, +0.2], 6 of 9; user cycles −10.3 M (−0.20%), 9 of 9.

**A trap this record fell into:** `tables/probe-musl.txt`, `tables/look-musl.txt` and their `v1` twins compare the
look on and off on two copies of one executable, with the setting in one side's environment alone. The two copies
drift apart in the page cache by a range or two (a sampled look, `khugepaged`), and an environment one variable longer
starts the stack elsewhere: the first version's probe read 17,600 kernel cycles a process so, and the head's −15,500.
Neither is the probe's. The table above is from one copy, with the setting on both sides (`=1` and `=0`).

## 4. A new executable's first runs

`scripts/first.sh`: a fresh copy, then compiles one after another, each counted, with the copy's state in the page
cache after each (`tables/first-*.txt`).

| | after run 0 | after run 1 | after run 2 |
| --- | ---: | ---: | ---: |
| `full`, a reflink's copy, `sqlite3.c` | 2,048 KB | 12,288 KB | 12,288 KB |
| `full`, a reflink's copy, musl's first units | 2,048 KB | 12,288 KB | 12,288 KB |
| `full`, a written copy (`cp --reflink=never`), `sqlite3.c` | 0 KB | 0 KB | 12,288 KB |

Kernel cycles of the first runs, `full` against main: `sqlite3.c` 237.4 M against 228.7 M, then 91.7 M against 87.1 M,
then 84.2 M against 86.3 M; musl's first two units 52.6 M and 16.6 M against 53.2 M and 9.1 M. The two looks are 7 M
to 13 M cycles. The kernel refuses to collapse pages that wait to be written, so a written copy's first two looks
fail at their first call.

## 5. The head

The runs of sections 1 to 4 were made with `full` at `29a46a0a…`. The pull request's head adds one check to
`lane_test.c` (a read that always faults) and changes no other code, so `scripts/last.sh` built `full` again
(`63045aa6…`) and ran main against it once more: `tables/head-full-*.txt`, the table of "In short". The same A/Bs
before it (`tables/ab-full-*.txt`): `sqlite3.c` −2.90 M kernel (−3.35%), musl a unit a process −816.7 M (−13.03%) and
−199.1 M user (−3.77%).

The tests of what the change touches pass on the head's build (`scripts/tests.sh`, `raw/results/tests-head`: 24
commands, each status 0): `test-profile`, `test-lanes`, `test-check-lanes`, `test-baked-tables`, `test-call-graph`,
`./build.sh check-call-graph --config Release`, `test-check-units`, `test-checker-deferred`, `test-checker --seed 133`
in 8 parts and `test-checker-driver --in-process` in 8 parts, with CI's clang as the oracle.

## The first version

`raw/v1.tar.xz` and `tables/v1` are the same runs for the first version of the helper (the probe in the helper; a 64 KB
window; the look in the file's order), from the same main: musl a unit a process −834.0 M kernel (−13.31%) and
−203.0 M user (−3.85%), `sqlite3.c` −2.90 M kernel (−3.33%). Its tables of the look on against off are section 3's
trap.

## Files

- `scripts/`: `build-tree.sh`, `build-both.sh` (the trees); `order.sh`, `regen.sh` (the traces and the list); `ab.sh`,
  `series.sh`, `series2.sh`, `extra.sh`, `same.sh`, `last.sh`, `final.sh`, `chain.sh` (the A/Bs and their order);
  `first.sh`, `peak.sh`, `peak-empty.sh`, `residual.sh`, `faultmap.sh`, `tests.sh`; `lock.sh`; `musl-common.sh` (the
  census's selection and options); `inputs/`; `tools/` (`abstat.c`, `collapse.c`, `faultsec.c`, `peakrss.c`,
  `waitall.c`, and the prototypes `starttrace.c`, `scanself.c`, `lookcost.c`); `simulate.py`, `analyze.py`,
  `summary.sh`; `t1.sh`, `t2.sh` and `aligned.patch`, the two experiments before the change (a collapse of main's own
  file by hand, and a prototype of the aligned link).
- `raw/`: `results/` (each run's counts, a CSV a side and round; `host.txt`; `pagecache.txt`; the tests' outputs),
  `build-*.out`, the series' logs, `holds.txt` (the lock's holds), `start-order-inputs.tar.xz`, `v1.tar.xz` (the
  first version's `results/`, logs and holds) and `experiments.tar.xz` (`t1.sh`'s and `t2.sh`'s results and logs, on
  main `56c2c294`: buster#2873's comment 6919328837 has their table).
- `tables/`: `abstat`'s table of each A/B, the residual faults, the first runs and the peaks.
