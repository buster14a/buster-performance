# The C driver's `-g` (#395 part 1, #426), 2026-10-25

The 9700X's validation and measurements of
[buster14a/buster#426](https://github.com/buster14a/buster/pull/426), part 1 of
[#395](https://github.com/buster14a/buster/issues/395): Tier 0's source rows and
the C driver's `-g`. Its reviews asked what the feature costs a compile without
`-g` (main against the pull request), what `-g` adds, and what the `-g` unit
costs the build and the executable.

| Run | Tree | Commit | Against | What it is |
| --- | --- | --- | --- | --- |
| `rows3-f0ef458/` | `part1` | `f0ef458` | `5863eed` | the head the first reviews read: source tokens tracked in the checker's unit |
| `rows4-a0c5b8c/` | `part1` | `a0c5b8c` | `5863eed` | `-g`'s link in a unit of its own, the tracking compiled out elsewhere |
| `rows5-06e6538/` | `part1` | `06e6538` | `4f4a0bf` | the same, with main merged twice and the arenas released before forwarding |
| `rows6-f34ac83/` | `part1` | `f34ac83` | `4f4a0bf`, `06e6538` | a link with `-g` records the expansion history as the unit runs |

`5863eed` is the pull request's merge base and `4f4a0bf` main when it was last
merged. Each tree is its commit's `git archive`, sent by tar; `source-*.sha256`
holds the SHA-256 of each of its files, which match the commit's archive byte for
byte. `binaries-*.sha256` holds the executables' and the input's. The scripts that
ran each run are its `queue.sh` (and `timed-build.py` for rows5's builds).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1, CPU 2 at
the performance governor. Each step took the shared lock on its own, through
`~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-linker-80` and
`EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/426`; `ab` took it for
each of its runs. The lock's waiting messages, which name other runs, are removed
from the logs; nothing else in them is changed. The compiler builds use
`BUSTER_DEBUG_INFO=0`, as the 9700X job builds, but rows5's builds with debug info.

## Inputs and method

The program is `benchmark-check-debug --print`'s: 2,000 generated functions,
31,269 lines (its SHA-256 in `binaries-rows3-rows4.sha256`; each run checks it is
the same file). A compile is the default C command to an executable,
`compiler [-g] -o program program.c`, which links against the C runtime's
snapshot.

- Wall time and peak RSS: `ab --rounds 5 --cpu 2` over `time-runs --runs 21`,
  whole processes pinned to CPU 2, the trees in rotating order; a tree's figure is
  the median of its five rounds' medians, with their range.
- Instructions and cycles: `perf stat -r 21` of the same compile pinned to CPU 2,
  in user mode, three rounds alternating the trees; the instruction counts repeat to
  a few instructions.
- The build (rows5): `build.sh` under `timed-build.py`, which reports the wall
  time and its children's CPU time and largest resident set
  (`getrusage(RUSAGE_CHILDREN)`), alternating main and the pull request three times
  without debug info and once with it; then `size` and the file's size.

## Results

### The cost found: `f0ef458` (rows3)

Without `-g`, `f0ef458` took **49.08 ms** against main's **48.45 ms** (+1.3%;
every round's median of part1, 49.02 to 49.12, above every one of main's, 48.37
to 48.66), with the same peak RSS (278,188 KB against 278,236), 633,483,427 user
instructions against 630,338,592 (+3.14 million, +0.50%) and 204.7 million cycles
against 201.3 (+1.7%) (`perfstat.log`). `local-bisection.md` attributes the instructions, on the
author's laptop: about 2 million were the lowering's own token tracking (a branch
on whether it's wanted costs as much as the store), and about 1.2 million came from
the checker's unit, which compiles the default C command, holding callers that
lower with sources or emit rows, which made clang compile the lowering and the
emission differently for every caller.

### The fix: `a0c5b8c` (rows4) and `06e6538` (rows5)

`run_check_command` sends a link with `-g` to a unit of its own
(`main_unit_debug.c`), whose lowering alone tracks the tokens
(`BUSTER_CHECK_SOURCE_ROWS`, a constant per unit); the tests and the benchmark that
ask for them are in that unit too.

| Without `-g` | main | pull request | Change |
| --- | ---: | ---: | ---: |
| `a0c5b8c` against `5863eed`: user instructions | 630,337,720 | 630,377,135 | +0.006% |
| cycles | 201.5 M | 203.1 M | +0.8% |
| wall time | 48.36 ms (47.88 to 48.58) | 48.81 ms (48.53 to 48.96) | +0.9% |
| peak RSS | 278,240 KB | 276,464 KB | -0.6% |
| `06e6538` against `4f4a0bf`: user instructions | 616,913,492 | 616,886,835 | -0.004% |
| cycles | 201.0 M | 200.1 M | -0.5% |
| wall time | 48.13 ms (48.07 to 48.21) | 47.84 ms (47.79 to 48.21) | -0.6% |
| peak RSS | 270,252 KB | 274,244 KB | +1.5% |

- Both compile the program into the same executable as main, byte for byte
  (`perfstat.log`'s last line), and retire the same instructions but tens of
  thousands, out of 617 to 630 million.
- What changes is where the code lands: the executable gains the `-g` unit's
  code, which moves the functions after it. The cycles and the wall time follow,
  by about 1% either way: up 0.9% at `a0c5b8c`, down 0.6% at `06e6538`, as the
  repository's guides measure between builds of the same code.
- So does the peak RSS, by about two huge pages either way, while the page
  faults barely move (1,344 against 1,340 at `a0c5b8c`, 1,152 against 1,187 at
  `06e6538`).
- rows4 passed `check-call-graph`, `test-check-debug --cross-check` (2,076
  checks), `test-checker --seed 133` (247,376), `test-tier0 --cross-check`,
  `test-debug --cross-check` and `test-checker-driver`, every one with 0
  failures.

### What the `-g` unit costs the build and the executable (rows5)

| Build | main | pull request | Change |
| --- | ---: | ---: | ---: |
| wall time, without debug info (3 builds each) | 41.51 s (40.93 to 41.59) | 41.84 s (40.86 to 42.67) | +0.8% |
| CPU time, without debug info | 338.6 s (337.9 to 340.1) | 374.0 s (373.7 to 375.7) | +10.5% |
| largest compiler process | 577,712 KB | 579,864 KB | +0.4% |
| wall time, with debug info (1 build each) | 51.38 s | 53.06 s | +3.3% |
| CPU time, with debug info | 419.8 s | 468.0 s | +11.5% |
| `build/compiler` text, without debug info | 24,506,386 B | 27,034,154 B | +10.3% |
| its data and bss | 10,901,996 + 238,962,873 B | 11,807,988 + 247,528,625 B | |
| `build/compiler` file, without debug info | 35,798,909 B | 39,274,071 B | +9.7% |
| `build/compiler` file, with debug info | 93,031,733 B | 103,044,559 B | +10.8% |

- The build runs its units at once, so its wall time is its longest unit's: the
  checker's, 40.8 to 42.6 s, with the `-g` unit second at 36.9 to 38.4 s
  (`build.sh`'s own report in each `build-*.log`). The `-g` unit adds about 35 s
  of CPU time to a build of 339 s.
- The executable gains the `-g` unit's copy of the pipeline (2.5 MB of text,
  0.9 MB of data and 8.6 MB of bss), which only a link with `-g` runs or touches:
  a compile without it faults about as many pages as main's.

### What `-g` adds

At `06e6538` (rows5's `ab-debug.log`), a link with `-g` took 53.11 ms against
47.82 without (+11.1%), peaking at 298,172 KB against 274,236 (+23.9 MB). At
`f0ef458` it had taken 51.07 against 49.00 (+4.2%), and 280,392 KB against
278,212 (+2.2 MB). The difference was main's: since
#425 the driver defers the expansion history until something reads it, and `-g`'s
rows read every function's tokens' expansion places, so the history was recorded by
preprocessing the unit a second time. `f34ac83` records it as the unit runs for a
link with `-g`, as `--scalar` does (rows6, below).

### `-g` after the fix: `f34ac83` (rows6)

| | Without `-g` | With `-g` | Change |
| --- | ---: | ---: | ---: |
| `06e6538`: user instructions | 616,886,727 | 665,079,454 | +7.8% |
| `f34ac83`: user instructions | 616,886,758 | 637,079,143 | +3.3% |
| `f34ac83`: cycles | 201.4 M | 214.7 M | +6.6% |
| `f34ac83`: wall time | 48.19 ms (48.11 to 48.20) | 51.24 ms (51.23 to 51.32) | +6.3% |
| `f34ac83`: peak RSS | 274,248 KB | 287,580 KB | +13,332 KB |
| `f34ac83`: page faults | 1,153 | 1,360 | |

- A link with `-g` retires 28 million fewer instructions than at `06e6538`
  (637.1 million against 665.1; 214.7 million cycles against 222.1) and writes the
  same executable (`perfstat.log`'s last line); a compile without `-g` retires the
  same instructions as `06e6538`'s, within 31.
- `-g` costs 3.05 ms and 13,332 KB of peak RSS over the same link without it: the debug rows'
  passes and DWARF, and the expansion history, which every compile recorded before
  #425 and only `-g`'s does now. At `f0ef458`, before #425, the history was in both
  links, and `-g` cost 2.07 ms and 2,180 KB.
- main (`4f4a0bf`) has no `-g` in the C driver: its compile with `-g` writes no
  DWARF and retires about the same instructions as without.

## Limitations

One generated program on one machine; the default compile's figures within about
1% move with where the code lands, as the two fixed heads' opposite signs show.
The build figures are three builds of each tree (one with debug info), on a
machine whose other sessions ran between the lock's holds. Peak RSS moves by a few
megabytes with the layout (huge pages). The laptop figures in
`local-bisection.md` only attribute the 9700X's difference.
