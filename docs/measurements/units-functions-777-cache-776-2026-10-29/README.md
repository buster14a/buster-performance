# A few large units' functions, and one cache for all the units, buster#777 and buster#776, 2026-10-29

Compiler branches of buster14a/buster, stacked on #763 (#152's driver of several translation units), #779 and #778:

- `claude/units-functions-777`, for [#777](https://github.com/buster14a/buster/issues/777): the units' lanes as a
  board, on which a unit's emission shares its functions' parts with the lanes that have no unit left to take, and
  lanes past the units as their sources pay for;
- `claude/units-cache-776`, for [#776](https://github.com/buster14a/buster/issues/776): an experiment, measured and
  not taken: #150's walk of every unit's files into one cache and table before the units, of which each lane's were
  copies (`--units-walk`). `experiment/units-walk-3ea2a6e5.diff` is its commit's diff.

## Sources and host

Each measured tree's `build.sh`, `src` and `tools` are those of a commit: `receipts/manifest-*.txt` (`sha256sum` of
every file, made on the host) are identical to the same of `git archive` of the commit, checked on the laptop:

- **t778m:** `51063d233ee9151014f329cb50c79ef9e51e23d4`, #778's branch with main merged into #763 under it (#777's base);
- **t777:** `015ca7c9848b3026dc02dd64af58dea36d385d71`, #777's board and its `lane_advance` test;
- **t777s:** `944d87fde3e7e67075763aee979bacc085f18a36`, #777's head: t777 with the board's idle lanes sleeping at once (`lane_sleep`);
- **t776:** `3ea2a6e54a609a57b3e85d5ccbade0ba017152c6`, #776's experiment on t777.

The executables' SHA-256 (in full in `receipts/receipts.log` and `logs/sl777.log`): t778m `972c9016…ead40bf0`, t777
`36524332…eed31121`, t777s `4c17a056…d3e79a90`, t776 `7adb1596…3f364f89`. Each was built
with `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds.

Host and tools as in [#778's and #779's record](../units-tail-778-779-2026-10-29/README.md) (the same
`receipts/receipts.log`, the same day): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1, perf 7.2.9;
CPU 2's governor `performance`, CPUs 0, 1 and 3 to 7's `powersave`. Inputs as there, and SQLite 3.53.4's amalgamation:
`sqlite3.c` (9,515,341 bytes, the same file as the frozen `sqlite3.c`) and `shell.c` (1,185,915 bytes, SHA-256
`8011ed01…11c85179`).

## Method

Every build, test and measurement took the host's lock for itself; each comparison is one hold. Whole processes are
`time-runs`: a warm-up, then N runs in an order that rotates by run, on CPUs 0 to 7, each one's median and range.

- `scripts/ev777.sh`: builds t778m and t777; runs at t777 `test-check-units` (with `--corpus` on c-testsuite),
  `test-check-lanes`, `test-checker-driver --executable`, `test-check-debug --cross-check`, `test-lanes` and the call
  graph check; then `sqlite3.c shell.c` with `-c` and linked by each, against the two units' processes at once (with
  `-c`, and with `-c` then `cc`'s link) and `sqlite3.c` alone (15 runs); and Lua's link (15), synth's (7) and musl's
  `-c` (7) by 8 lanes and by one, by each.
- `scripts/aa777.sh`: the `-c` comparison again with each row twice (A/A), 21 runs, at t777.
- `scripts/sl777.sh`: builds t777s; its units and lane tests; the `-c` comparison with each row twice, t777 against
  t777s (21 runs); the link (15); Lua's, synth's and musl's commands by 8 lanes (15, 5, 7).
- `scripts/pr777st.sh`: `--time-stages` of the one command and of `sqlite3.c` alone, five runs each, at t777s.
- `scripts/ev776.sh`: builds t776; its units test (with `--corpus`), `test-files` and the call graph check; then by one
  executable without and with `--units-walk`: `--time-stages` by 8 lanes (three runs each), and Lua's link (15 runs),
  synth's (5) and musl's `-c` (7) by 1, 2, 4 and 8 lanes; and `benchmark-files` of the same roots and options.

`scripts/keep_own_lines.py` kept only the lines the scripts and the tools print (`logs/`): it dropped the lock's
waiting messages, which name other jobs, and nothing else.

## Results

### #777's tests (`logs/ev777.log`, `logs/sl777.log`)

At t777: `test-check-units` 552 checks (319 of the large unit's parts taken by lanes without units), `--corpus` 448,
`test-check-lanes` 3,640, `test-checker-driver --executable` 38,531, `test-check-debug --cross-check` 2,548, all with 0
failures; `test-lanes` with its advance check on 1, 2, 3 and 8 lanes (lane 0 slept 4 times on 8); 0 cycles and 0 split
variables. At t777s: `test-check-units` 552 and `test-lanes`, 0 failures.

### A few large units (`logs/ev777.log`, `logs/aa777.log`, `logs/sl777.log`)

`sqlite3.c` and `shell.c`, medians (ranges):

| ms | t778m | t777 | t777s | two processes at once |
| --- | ---: | ---: | ---: | ---: |
| `-c` (ev777, 15 runs) | 133.86 (132.25–135.17) | 122.25 (121.59–124.39) | | 121.09 (120.05–121.92) |
| `-c`, A/A (aa777, 21 runs) | | 122.66, 122.13 | | 121.28, 121.14 |
| `-c`, A/A (sl777, 21 runs) | | 122.42, 122.99 | 122.04, 122.18 | 121.08, 120.85 |
| linked (ev777, 15 runs) | 138.25 (135.25–139.42) | 127.03 (122.99–127.95) | | 137.77, `-c` then `cc` |
| linked (sl777, 15 runs) | | 125.99 | 125.97 | |

`sqlite3.c` alone with `-c` by t777 took 114.10 ms (113.33–115.55), and by one lane 127.06. The one command's
default run reported 1,020 parts taken by lanes without units. Peak resident sets: the one command 536 to 545 MB
(t778m's 436 to 439), the larger of the two processes 424. User time of the one command: t777 191 to 196 ms, t777s 164
to 171, the two processes 170 to 178.

`--time-stages` (`logs/pr777st.log`, t777s, medians of five): the one command's `setup` 0.99 ms, `lanes` 120.29,
`release` 0.24, `total` 121.50; `sqlite3.c` alone `total` 112.34 (its function lanes 5.12).

### Lua, synth and musl by #777 (`logs/ev777.log`, `logs/sl777.log`)

| median ms | t778m | t777 | t777s |
| --- | ---: | ---: | ---: |
| Lua linked, 8 lanes | 34.65 | 34.47 (ev777); 34.77 (sl777) | 34.55 |
| Lua linked, 1 lane | 80.10 | 79.69 | |
| synth linked, 8 lanes | 528.40 | 530.34; 529.87 | 530.66 |
| synth linked, 1 lane | 1,640.71 | 1,617.15 | |
| musl `-c`, 8 lanes | 240.57 | 238.36; 233.54 | 237.86 |
| musl `-c`, 1 lane | 644.52 | 641.02 | |

Peaks by 8 lanes: synth 536 to 538 MB, Lua 210 to 213, musl 250 to 251, alike for every tree.

### #776's walk (`logs/ev776.log`)

At t776: `test-check-units` 608 checks and `--corpus` 670 (220 of 220 objects as alone with the walk), `test-files`
passed, 0 cycles and 0 split variables. One executable without and with `--units-walk`:

| median ms | lanes | without | with the walk |
| --- | ---: | ---: | ---: |
| Lua linked (15 runs) | 1 | 76.28 | 76.40 |
| | 2 | 46.05 | 46.93 |
| | 4 | 33.61 | 33.96 |
| | 8 | 31.35 | 32.27 |
| synth linked (5 runs) | 1 | 1,629.11 | 1,620.05 |
| | 2 | 917.28 | 935.84 |
| | 4 | 619.00 | 671.96 |
| | 8 | 527.75 | 602.13 |
| musl `-c` (7 runs) | 1 | 641.36 | 638.84 |
| | 2 | 387.95 | 390.91 |
| | 4 | 262.97 | 266.83 |
| | 8 | 235.01 | 243.15 |

By 8 lanes, `--time-stages`' medians of three: the walk 3.47 ms (Lua: 7 rounds, 242 files, 1.69 MB, 227,320 tokens),
21.20 ms (synth: 6 rounds, 561 files, 62 MB, 12.9 million tokens) and 4.41 ms (musl: 4 rounds, 1,221 files, 1.96 MB);
the lanes' run 27.27 and 25.47 ms (Lua), 498.87 and 540.67 (synth), 209.37 and 209.83 (musl). Peaks by 8 lanes:
212,124 and 230,076 KB (Lua), 537,868 and 625,240 (synth), 251,812 and 311,976 (musl).

`benchmark-files` (the walk from nothing): Lua's roots 1.37 ms on one lane and 1.98 on 8 (47 of the 242 files no unit
entered, 8.5% of the tokens), musl's 3.79 and 3.27 (none unused), synth's 30.03 and 20.19.

## Limitations

- The governors were not all `performance`. Whole processes 5 to 21 runs; stages 3 to 5.
- t778m and t777 carry main's commits up to `7a1f7373`, which #778's own record (t778) didn't: their synth and musl
  times by one lane are 4% to 6% above t778's there (the same corpora), for main's changes, which this record doesn't
  attribute.
- The one command's 0.9% against the two processes is inside one address space; this record doesn't break it down
  further than the stages above.
