# #151's decision: a unit's function bodies checked on its lanes

Evidence for [buster#1403](https://github.com/buster14a/buster/pull/1403), which closes the last
Done-when item of [buster#151](https://github.com/buster14a/buster/issues/151): whether the bodies'
checking (and parsing) goes on lanes, decided from the measured serial share. The PR runs
[#113](https://github.com/buster14a/buster/issues/113)'s deferred reader from the C driver with
`--deferred-bodies`. The bodies' walks and the merge's pass run as rounds of the command's flow, on
the session's lanes. This record measures it against source order's reader, which stays the
default.

All timings are from the Ryzen 7 9700X (`benchpress`). Each compile ran under the host's shared
lock (`exclusive.sh`, taken per command) on CPUs 0–7, one per core. There, the driver's default is
eight lanes.

## Sources

| Name | Revision | What |
| --- | --- | --- |
| main | buster `483e5f70d54ff8adccf011e773de4c04abd6489c` | the PR's base |
| head | buster `4452efbc99a6370bf4279b1243a51e2f91c75ef6` | the PR's first head, which these figures measure |

`raw/identity.txt` has:
- both executables' SHA-256 and the frozen `sqlite3.c`'s (`0a409f16…`, corpus
  `preprocessor-391e729af658`);
- Linux 6.18.50-2-lts, clang 23.1.1, 15 CPUs online;
- the governors: CPU 2 `performance`, the others `powersave`;
- the object comparisons.

Both trees were built by `./build.sh` with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`. Every
`sqlite3.c`, `main.c` and small-unit object compared equal across modes, and `main`'s `sqlite3.c`
objects equal `head`'s.

## Method

- [`scripts/final.sh`](scripts/final.sh) `main final` made everything in `raw/` but the
  `lane0-functions--*.tsv` files:
  - `time-runs` of whole processes in rotated order;
  - the lanes' sweep by `--time-stages`;
  - `benchmark-checker-deferred`;
  - `main.c`;
  - a small unit.

  Its step 6 printed no function names: `perf script` gives `sym` only with `ip`. Its empty output
  was dropped.
- [`scripts/profile.sh`](scripts/profile.sh) replaced it: perf's user cycles at 20 kHz, one run in
  each mode, by function, of lane 0 alone (the thread whose tid is the process's pid).
- [`scripts/warnings.sh`](scripts/warnings.sh) made `raw/warnings.txt`.
- The `sqlite3.c` options are those of the 9700X job's compile-time step:
  `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I…`,
  with the host's system headers.

The main comparisons use `-w`. With warnings on, #1049's common warnings add about 48 ms to
`check-program`, which `-w` skips (buster#1340). `raw/warnings.txt` shows that the cost isn't the
one `-Wempty-body` warning buster#1339 tracks: without it (`-Wno-empty-body`), `check-program` still
takes 58 ms, against 10 ms with `-w`. The default compile is measured too.

## Results

**The whole process**, `-c sqlite3.c`, 21 runs each, by default (8 lanes), medians (`raw/time-runs--w.txt`
and `raw/time-runs-warnings.txt`):

| | `-w`, source order | `-w`, deferred bodies | with warnings, source order | with warnings, deferred bodies |
| --- | ---: | ---: | ---: | ---: |
| wall | 108.24 ms | 105.66 ms (−2.4%) | 158.88 ms | 157.17 ms (−1.1%) |
| wall's range | 107.44–109.84 | 104.30–109.29 | 158.23–160.30 | 155.30–160.74 |
| user cycles | 623.8 M | 703.7 M (+12.8%) | 890.4 M | 971.0 M (+9.0%) |
| minor faults | 8,552 | 23,577 | 9,095 | 24,123 |
| wait4 peak | 325,332 KiB | 356,528 KiB | 343,644 KiB | 374,940 KiB |

**Main against head without the option**, 11 runs each (`raw/time-runs-main-*.txt`): −0.54% wall
and −0.16% user cycles with `-w`; −0.48% and −0.04% with warnings.

**`check-input` by lanes**: `--time-stages` of `-c -w sqlite3.c`, `--lanes N`, 11 runs each, medians
in ms (`raw/sweep.tsv`; `raw/stages--*-N.txt` is each count's last run). With `--lanes 1` the driver
doesn't defer.

| `--lanes` | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| source order | 56.63 | 56.66 | 56.87 | 56.73 | 56.69 | 56.94 | 56.89 | 56.75 |
| deferred bodies | (56.74) | 59.71 | 56.58 | 55.41 | 54.53 | 54.18 | 53.95 | 53.77 |
| the stages' total, source order | 117.45 | 111.72 | 109.68 | 108.36 | 108.04 | 107.53 | 107.59 | 107.59 |
| the stages' total, deferred bodies | (117.16) | 114.83 | 109.58 | 107.61 | 106.00 | 105.30 | 104.93 | 104.81 |

**The reading's phases**: `benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7`
(`raw/benchmark-checker-deferred.txt`), in ns/token, over 716,136 tokens and 2,674 bodies:

| | source order | deferred, 1 lane | deferred, 8 lanes |
| --- | ---: | ---: | ---: |
| the whole reading | 74.03 | 89.10 | 68.21 |
| the top level's walk | | 22.78 | 22.57 |
| the lanes' span (the bodies' walks, their position checks, each lane's copy) | | 23.10 | 5.65 |
| the merge (its pass on the lanes) | | 5.82 (4.44) | 2.35 (0.99) |
| `check_input_run`'s phases after the merge | | 37.00 | 37.29 |

**Lane 0's functions** (`raw/lane0-functions--*.tsv`): one run each, about 1,900 samples of lane
0, so the shares are rough. With deferred bodies, `check_input_resolve_range` (the walk) falls from
6.2% to 2.5% of lane 0's samples. `check_input_run` (the phases it inlines), the expressions' walk
(`check_input_expression_coded`, 5.9%), the graph run (5.8%), `check_program` (4.1%) and the
bindings' answers (3.6%) stay on lane 0.

**`main.c`** (`raw/main.c--*.txt`): `-c -w -march=znver5 -Isrc -fwrapv -funsigned-char
-fno-strict-aliasing`, 3 runs each. Its `#pragma clang section` lines send it to source order
before the top level's walk (`deferred-merged #pragma clang section`): 1,832–1,834 ms without the
option, 1,834–1,844 ms with it.

**A small unit** (`raw/small.c`: 24 functions and `main`, 41 runs each, `raw/time-runs-small.txt`):
2.256 ms against 2.280 ms with the option, ranges 2.105–2.640 and 2.110–2.632. User cycles
+0.1%, 916 and 932 minor faults. Its bodies take one lane, so it reads in source order.

## The serial share

- **The reading.** On 8 lanes, the lanes take 5.65 + 0.99 of the deferred reading's 68.21 ns/token.
  The other 90% is serial: the top level's walk (22.57), the phases after the merge (37.29) and the
  merge's serial part. The sweep shows the same: from 4 lanes to 8, `check-input` gains 1.6 ms.
  Two lanes are slower than source order, and three break even.
- **The compile.** On 8 lanes with deferred bodies, `--time-stages` gives 104.6 ms. About 9 ms of it
  is on lanes: the emission (4.6), the bodies' walks (about 4) and the merge's pass (0.7). The rest
  is serial:
  - `check-input` outside its lanes, about 49 ms;
  - preprocessing, 10.1;
  - `check-expressions`, 10.1;
  - `check-program`, 10.1 (58 with warnings, buster#1340);
  - the parse, 7.4;
  - the rest, about 8.

The decision and its design are in buster's `docs/function-lanes.md`, "The checker's bodies on
lanes", at the PR's head.

## Limitations

- One host, one placement of each build, one large unit (`sqlite3.c`) that merges. `main.c` goes to
  source order by design, and the small unit by its tokens.
- `time-runs`' wall time includes each process's exit, which unmaps the deferred reader's extra
  pages. `--time-stages`' total doesn't, so its gain (2.8 ms) is larger than the whole process's
  (2.6 ms).
- The lane-0 profile is one run per mode.
- Nothing here measures several compiles at once, where the 12.8% more user cycles would compete
  for the cores.

The scripts are original project work under Apache-2.0 WITH LLVM-exception. The measured inputs
(SQLite, the system headers) are external runtime inputs, not incorporated here.
