# The deferred merge's pass on the bodies' lanes, 2026-10-28

The 9700X's measurements for the Buster PR of issue [#697](https://github.com/buster14a/buster/issues/697)'s item 1,
the merge's serial work. The PR cuts the merge's pass over every token's columns and the binding events. The
columns' entries are found 64 tokens at a time with a scalar twin, and the pass runs on the lanes the bodies ran on.
It is the second of the three PRs that #697's claim names. Cited by Buster's `docs/c-deferred-bodies.md`.

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main` | `16d5c617`: main with #697's item 4 (#719) merged, the PR's base | 523 | `a6aabf2ed0946d2d1c52c27a8fe1dfab000cc5c0b753d6c8ee4f1e6e6db7443d` |
| `a` | `23edaa12`: `main` with the merge's parts timed (`benchmark-checker-deferred`'s "merge's parts"), the base of the comparison | 523 | `1e0c1e7fa4b61fed3220e320ac003c256b6219638d60be609dfbb784e1c783e0` |
| `b` | `0d64856b`: `a` with the column entries found 64 tokens at a time | 523 | `8a7ee1c86fb4cf20ca5fb843f80409d8d385172c22f4ccb5c16705eb5f9e80c1` |
| `c` | `d3384431`: `b` with the pass on the bodies' lanes | 523 | `30f89f4b64ff40dd2f7cbd0d3899feaf67f7a42b3b3c4c7c742b68647c9cdaa5` |

Each manifest (`source-*.sha256`) lists the SHA-256 of `build.sh` and of every file under `src/` of the tree, in the
order `sha256sum build.sh; find src -type f | LC_ALL=C sort | xargs sha256sum` writes them, from `git archive` of its
commit. Each tree was built on the host by Buster's `./build.sh` with `BUSTER_DEBUG_INFO=0`, as the 9700X job builds
it.

The inputs are the frozen corpora of [#113's record](../deferred-bodies-113-2026-10-25/README.md): its `sqlite3.c`
(706,237 tokens, 2,608 bodies) with its pinned predefines and headers, musl's `src` and c-testsuite at commit
`5c7275656d751de0e68b2d340a95b5681858ed07`.

## Method

`scripts/head.sh` checked out the three commits in clones of their own, built each, ran the checks below on `c`, then
six rounds of one benchmark process per build, `a`, `b` and `c` in that order each round:

```sh
./build/compiler benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 --predefines PINNED --clang-features [the frozen options] sqlite3.c
```

with `SOURCE_DATE_EPOCH=1792454400` and `CPATH` and `C_INCLUDE_PATH` unset. Each pass parses the unit and reads it by
source order's `check_input` and by the deferred reader on one lane and on eight, in the six orders of the three
readings in turn. Every deferred reading releases its state first, as a process's one reading does. A figure is the
median of a process's passes, in nanoseconds per token. Each process, build and check took a lock hold of its own. The
host is the AMD Ryzen 7 9700X with the host's clang 23.1.1 (`/usr/bin/clang`, as in the earlier deferred records) and
wild as `build.sh`'s linker. CPU 2 runs the performance governor and the other CPUs powersave (#448's record).

`scripts/summarize.py` reads the log's benchmark processes into each build's median and range over its six processes
(`tables/summary.txt`), and each process's deferred reading on eight lanes against its own source order's reading.

The traces were made before main moved on: `b`'s and `c`'s code applied to Buster `f1f4abfc` (#719's head, which main
`16d5c617` merges), with instrumentation that is not in the PR, each a benchmark process of 12 passes on the same
`sqlite3.c` (`scripts/trace*.sh`, `logs/trace*.txt`):

- the events' trace (`b`'s code): the merge's events part timed by step, with the page faults of each part of the
  merge (`getrusage`'s minor faults of the calling thread);
- the pass's lanes (`c`'s code): each lane's start after the pass's `lane_run`, and the nanoseconds of its events and
  of its tokens, with the tokens' count it took;
- a cursor over the bodies' parameters (`scripts/item1-cursor.diff`), in place of the owner lookup's walk of the next
  body's parameter chain, traced as the pass's lanes are.

## Results

The medians over the six processes of each build, their range in parentheses, in nanoseconds per token
(`tables/summary.txt`):

| | `a`: the parts timed | `b`: the scan | `c`: the pass on the lanes |
| --- | ---: | ---: | ---: |
| source order | 68.78 (68.55 to 69.14) | 69.02 (68.82 to 69.33) | 69.04 (68.97 to 69.80) |
| one lane: the reading | 86.36 (86.19 to 86.65) | 84.49 (84.17 to 85.07) | 84.73 (84.26 to 85.02) |
| one lane: the merge | 7.02 (6.99 to 7.08) | 5.16 (5.12 to 5.17) | 5.04 (4.99 to 5.05) |
| eight lanes: the reading | 73.48 (73.32 to 74.04) | 71.29 (71.16 to 71.65) | 69.34 (69.00 to 69.50) |
| eight lanes: the top level | 23.11 | 23.25 | 23.26 |
| eight lanes: the lanes' span | 5.38 | 5.38 | 5.40 |
| eight lanes: the merge | 7.27 (7.26 to 7.31) | 5.39 (5.37 to 5.43) | 2.62 (2.60 to 2.63) |
| eight lanes: the later phases | 37.43 | 37.10 | 37.64 |
| eight lanes against source order, each process's | +6.84% (+6.74 to +7.12) | +3.28% (+3.07 to +3.70) | −0.01% (−0.43 to +0.52) |

The merge's parts on eight lanes:

| | `a` | `b` | `c` |
| --- | ---: | ---: | ---: |
| the replay | 0.571 | 0.567 | 0.563 |
| the appended tables | 0.139 | 0.140 | 0.145 |
| the events | 1.263 | 1.252 | 0.063 |
| the tags' completions | 0.126 | 0.126 | 0.131 |
| the pass (in `a` and `b` the token columns alone) | 5.136 | 3.259 | 1.651 |
| the rest | 0.048 | 0.046 | 0.054 |

On one lane, `c`'s pass, with the events' copies in it, is 4.20 ns/token, against `b`'s 3.13 for the token columns and
1.26 for the events.

So the scan takes the merge on one lane from 7.02 to 5.16 ns/token, and the pass on eight lanes takes it from 5.39 to
2.62. On eight lanes the deferred reader goes from 6.8% slower than source order to even with it, within each process's
−0.43 to +0.52%. On one lane it stays 22.4% slower. Source order's reading and the top level's walk don't change: the
three builds read them within 0.7% of each other. Across builds, code placement alone can move a reading by about 2% on
this host (Buster's `docs/profiling.md`), so the comparisons that decide are within a process: each deferred reading
against its own source order.

The traces (`logs/trace*.txt`, on `f1f4abfc` with `b`'s and `c`'s code):

- **The events.** Steady state, the bodies' 137,621 events took 0.72 ms to copy and the top level's 26,700 took 0.13
  ms. The first reading of the process faulted 9 huge pages for the merged stream's arrays, and none after.
- **The pass's lanes.** Each lane starts 6 to 24 µs after the pass's `lane_run`. Each lane but the first takes its 88,000
  to 102,000 tokens in 0.9 to 1.1 ms, where one lane takes all 706,237 in about 2.1 ms (and their events in 0.8 ms more).
  So each of eight lanes scans a token at about a third of one lane's speed: the lanes share the memory's bandwidth.
- **The cursor.** One lane's token columns took 1.96 to 2.04 ms with the cursor, against 2.04 to 2.16 without it, and
  eight lanes' were unchanged. The PR keeps the walk.

## Checks

On `c`, each command a lock hold of its own (`logs/head.txt`):

| Command | Result |
| --- | --- |
| `test-checker-deferred` | 101 fixtures, 1,966 checks, 1,020 merged, 30,000 bodies read apart, 0 failures |
| `test-checker --seed 133` | 497,230 checks, 4 failures: the program oracle's fpclassify fixtures, with the host's clang 23.1.1 (below) |
| `test-lanes` | every check passes (52 arena checks; on 1, 2, 3 and 8 lanes, 8,008 ranges, 10,000 rounds, 9 exchanges and 13 parts inputs, none wrong) |
| `test-checker-corpus --clang /usr/bin/clang --deferred 8` on c-testsuite | 220 units merged, 0 left to source order, 449 bodies, 0 differences; all 220 programs as clang has them |
| the same on the frozen `sqlite3.c`, with `--symbols` | 1 unit merged, 2,608 bodies, 0 differences; its functions and objects clang's (0 unexplained, 1 documented inline) |
| the same on the frozen musl's `src` | 1,486 units merged, 38 left to source order, 21,918 bodies, 0 differences; 1,484 of 1,524 files accepted, as clang |
| `./build.sh check-call-graph` | 41 units, 25,607 functions, 0 cycles (3 allowed), 0 split variables |

`test-checker`'s four failures are its program oracle's fpclassify fixtures (`fpclassify-conditional-selector-effects`
and `fpclassify-known-category-effects`), whose selectors' side effects come out in another order than the host's clang
23.1.1 gives them. `scripts/checker-clang.sh` (`logs/checker-clang.txt`) ran the same command on `a`, which the PR's
deferred reader changes don't reach, with the same four failures, and on `c` with clang 23.1.4 first on `PATH` (the
toolchain the 9700X's CI job stages), with none.

## Files

- `scripts/head.sh`: the PR's commits built, checked and timed (`logs/head.txt`), and `scripts/summarize.py`, which
  makes `tables/summary.txt` from the log.
- `scripts/checker-clang.sh`: `test-checker` on `a` with the host's clang and on `c` with clang 23.1.4
  (`logs/checker-clang.txt`).
- `scripts/trace.sh`, `scripts/item1-scan.diff` and `scripts/item1-trace.diff`: the events' trace on `b`'s code
  (applied to Buster `f1f4abfc`, #719's head), which timed the events' copies and counted page faults per part of the
  merge (`logs/trace.txt`).
- `scripts/trace2.sh`, `scripts/item1-pass2.diff` and `scripts/item1-pass-trace.diff`: the pass's lanes traced on
  `c`'s code (applied to `f1f4abfc`), each lane's start, events and tokens (`logs/trace2.txt`).
- `scripts/trace3.sh`, `scripts/item1-cursor.diff` and `scripts/item1-cursor-trace.diff`: the cursor's variant of `c`'s
  code (applied to `f1f4abfc`), traced as `trace2.sh` traces `c`'s (`logs/trace3.txt`).

The logs are as the runs wrote them, each run's heading, its output, its lock's waits and its exit status. The
scripts, the record and the diffs are original project work.

## Limitations

One host, one input: the frozen `sqlite3.c`, whose merge these changes target; units of fewer bodies merge in far less
time. The builds ran in the same order in every round. The traces ran on #719's head with `b`'s and `c`'s code applied,
not on these commits, and their instrumentation adds its own calls; they explain the campaign's figures and are not
part of them. The timing claims are this campaign's, on these frozen commits; later heads have no timing campaign here.
