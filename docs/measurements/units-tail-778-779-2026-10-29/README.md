# The units' link tail and their DWARF, buster#778 and buster#779, 2026-10-29

Compiler branches of buster14a/buster, stacked on #763 (`claude/solve-152-eda9b1`, #152's driver of several
translation units):

- `claude/units-debug-779`, for [#779](https://github.com/buster14a/buster/issues/779): `-g` for an executable of
  several units (each unit's DWARF kept with its link, and joined by the merge);
- `claude/units-tail-778`, for [#778](https://github.com/buster14a/buster/issues/778): the link after the units'
  lanes: `--time-stages`' split of the direct path, the lanes releasing their own memory, one team for the command,
  the units' merge and `link_check` on the units' lanes, and the write's phases.

This record has the 9700X evidence both pull requests cite: the tests at #778's head, the link's stages, whole
processes against #763's head, `-g`'s cost, and the one-file commands.

## Sources and host

Each measured tree's `build.sh`, `src` and `tools` are those of a commit: `receipts/manifest-*.txt` (`sha256sum` of
every file, made on the host) are identical to the same of `git archive` of the commit, checked on the laptop
(`receipts/receipts.log` also lists the trees and executables of #777's and #776's record, measured the same day):

- **t763:** `29770b8524c916733dad728b51c0923cca416969`, #763's head before its merge of main (the base);
- **t779:** `520ba859d388a6b71fd85a015bcab6088f80df74`, #779's commit on it;
- **ccad:** `ccad85a67cfd780e0bf208f92457c6baaf871a49`, #778's first commit (the stage split alone) on #779;
- **t778:** `3c615fdae4f128a3014cf73fa283d3b54f177c48`, #778's head with its merge test (`736cc02d`, after it, changes
  only documentation).

The executables' SHA-256, as `receipts/receipts.log` prints them: t763 `873cf080…d4063c98`, t779 `49513a87…508cf713`,
ccad `ce4de486…0d886f7e`, t778 `0c28a1bd…57d5c6ee` (full hashes in the log). Each was built with
`BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds.

Host (`receipts/receipts.log`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1, perf 7.2.9, gdb
18.1, LLVM 23.1.1's tools; transparent huge pages `always`, defrag `madvise`. CPU 2's governor was `performance`
and CPUs 0, 1 and 3 to 7's `powersave`: the multicore rows ran on all eight, alike for every executable.

Inputs (`receipts/receipts.log`): `sqlite3.c` SHA-256 `b1dd5d74…db28189`; c-testsuite's `00220.c`; Lua 5.4.8's
interpreter, its 33 units but `luac.c`; synth's shape, `test-check-units --generate`'s 512 units of 200 functions;
musl 1.2.5's library sources selected for x86-64 as its Makefile selects them, of which the driver compiles 1,006
(the same probe as #152's record).

## Method

Every build, test and measurement took the host's lock (`exclusive.sh`) for itself; each corpus's rows are one hold.

- `scripts/ev778.sh`: builds t763, t779 and t778; runs at t778 the tests that #778 changes; `--time-stages` of synth's
  link and Lua's (plain and `-g`) by `--lanes` 8 and 1, three runs each; whole processes (`time-runs`: a warm-up,
  then N runs in an order that rotates by run, and each one's median) on CPUs 0 to 7, one per core, of synth's link
  (7 runs), Lua's link by t763, t779 and t778 and with `-g` by t779 and t778 (15 runs), and musl's `-c` (7 runs); and
  the one-file A/B: `perf stat -r 11` on CPU 2 of `-c sqlite3.c`, `-fsyntax-only sqlite3.c` and the link of
  `00220.c`, in three rounds of a rotating order, of t763, an A/A copy of t763's executable, t779 and t778.
- `scripts/st778.sh`: builds ccad and runs `--time-stages` of synth's and Lua's links by `--lanes` 8 and 1, three
  runs each, ccad and t778 in turn.
- `scripts/musl778.sh`: musl's `-c` by 8 lanes again, t763 against t778, 21 runs.
- `scripts/receipts778.sh`: the host, tools, binaries, manifests and inputs.

The lock's waiting messages name other jobs: `scripts/keep_own_lines.py` kept only the lines the scripts and the
tools print (`logs/`); it dropped nothing else.

## Results

### Tests at #778's head (t778, `logs/ev778.log`)

`test-check-units` 541 checks, `--corpus` (c-testsuite's 220 programs) 448, `test-checker-driver --executable`
37,995, `test-check-debug --cross-check` 2,548, `test-check-lanes` 3,634, all with 0 failures; `test-call-graph` 37
cases and `./build.sh check-call-graph` 0 cycles, 0 split variables.

### The link's stages (`logs/st778.log`, medians of three runs)

Synth's 512 units linked by 8 lanes, the stage split alone (ccad) against #778 (t778):

| ms | ccad | t778 |
| --- | ---: | ---: |
| `lanes` (the units' run) | 485.40 | 483.24 |
| `code-atoms` (the units' merge) | 18.48 | 9.57 |
| `runtime` | 3.62 | 3.59 |
| `executable` (binding, `link_check`, the inputs) | 4.88 | 1.21 |
| `write` | 11.38 | 10.99 |
| `release` | 8.97 | 0.64 |
| `total` | 532.93 | 510.72 |

By one lane, t778's merge is the twin's (19.69 ms, ccad 18.81), and its release (0.27 ms against 4.95) moved into
`lanes` (1,493.67 against 1,488.71): the totals are 1,541.93 and 1,540.98. Lua's link by 8 lanes: `total` 32.28 against
33.35 ms (release 0.31 against 1.47). The write's phases (`time-write`, t778): by 8 lanes `chunks` 10.14 ms of the
write's 10.99; by one 14.22 of 17.73.

`runtime` took 3.4 to 4.2 ms in every run of this A/B: each executable found the other's runtime snapshot, which a
snapshot is only for the executable that wrote it, and imported the runtime again. In `logs/ev778.log`'s runs, one
executable after another, it took 0.08 to 0.10 ms after the first.

### Whole processes against #763 (`logs/ev778.log`, `logs/musl778.log`)

| median ms (range) | t763 | t779 | t778 |
| --- | ---: | ---: | ---: |
| synth linked, 8 lanes (7 runs) | 531.37 (529.02–541.39) | | 518.14 (513.41–527.93) |
| synth linked, 1 lane | 1,546.71 (1,536.39–1,556.96) | | 1,547.03 (1,540.28–1,555.24) |
| Lua linked, 8 lanes (15 runs) | 34.94 (34.04–43.89) | 34.24 (33.26–38.79) | 34.30 (33.72–36.65) |
| Lua linked with `-g`, 8 lanes | | 35.54 (32.05–36.42) | 35.49 (31.69–36.86) |
| Lua linked, 1 lane | 78.79 (77.54–88.75) | 78.44 (77.63–79.90) | 78.12 (77.03–79.58) |
| Lua linked with `-g`, 1 lane | | 83.51 (79.61–85.24) | 83.09 (79.10–84.47) |
| musl `-c`, 8 lanes (21 runs) | 231.48 (226.28–258.05) | | 231.80 (227.49–249.40) |
| musl `-c`, 1 lane (7 runs) | 621.85 (617.27–639.08) | | 620.71 (615.57–634.64) |

Peak resident sets: synth by 8 lanes 537,508 and 539,160 KB, Lua by 8 lanes 212,692 to 214,544 KB plain and 224,612
to 225,192 KB with `-g`. musl's first 7-run comparison (`logs/ev778.log`: 239.71 against 245.19 ms, ranges 224.78–270.09
and 228.67–293.86) did not establish a throughput difference. The 21-run follow-up reports nearly equal medians,
231.48 and 231.80 ms; these retained summaries do not establish a musl throughput change.

### One file (`ab/`, `logs/ev778.log`)

`perf stat -r 11` on CPU 2, the medians of three rounds:

| | t763 | t763's copy | t779 | t778 |
| --- | ---: | ---: | ---: | ---: |
| `-c sqlite3.c`, user instructions | 1,231,155,550 | 1,231,155,542 | 1,231,147,678 | 1,231,147,726 |
| `-c sqlite3.c`, user cycles | 567.47 M | 569.95 M | 569.86 M | 563.32 M |
| `-c sqlite3.c`, task clock | 119.96 ms | 120.65 ms | 120.41 ms | 119.30 ms |
| `-fsyntax-only sqlite3.c`, user instructions | 932,804,127 | 932,804,118 | 932,795,967 | 932,796,233 |
| `-fsyntax-only sqlite3.c`, user cycles | 430.71 M | 431.10 M | 435.06 M | 428.54 M |
| `-fsyntax-only sqlite3.c`, task clock | 93.91 ms | 94.15 ms | 94.64 ms | 93.63 ms |
| link of `00220.c`, user instructions | 21,378,060 | 21,378,060 | 21,377,524 | 21,377,848 |
| link of `00220.c`, task clock | 2.75 ms | 2.75 ms | 2.74 ms | 2.69 ms |

The three heads' objects of `sqlite3.c` are the same bytes. t779's `-fsyntax-only` cycles are 1.0% above t763's, where
the copy's are 0.1% above; t778, which holds t779's change, is 0.5% below: placement, as #152's record found for
differences of this size.

## Limitations

- Three `--time-stages` runs per configuration; whole processes 7, 15 or 21 runs. The governors were not all
  `performance`.
- The stages' A/B alternated two executables, which made each one's runtime snapshot stale for the other (above).
- Lua's ranges overlap between the heads; synth's 8-lane ranges do not overlap, and musl's 21-run medians are
  nearly equal. The retained musl summaries do not establish a throughput difference or statistical equivalence.
