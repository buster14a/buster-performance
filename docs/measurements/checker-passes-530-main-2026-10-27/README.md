# The checker's graph and program passes on sqlite3.c, against main after #520

Raw evidence for buster's `docs/compile-time.md` (buster14a/buster#530, PR
#573): the C driver's `-c` of SQLite 3.53.2's `sqlite3.c` by main and by
#573's head, interleaved on the 9700X, with `--time-stages`' report of each
stage, perf's counters of the whole compile and `benchmark-checker-source`'s
time per node of the graph run; then a probe of `check-declarations`, the one
stage that got slower.

[The first record](../checker-passes-530-2026-10-27/README.md) measured #573's
first head (`0b5af444`) against #520's branch merged into the main of the time
(`373ce21b`). PR #573's second review asked for the same protocol against the
main it had merged by then, `a774acd2`, and that merge, `2163d68a`.

## Identity

- **Revisions** (buster):
  - main: `a774acd26a357c4b847f5253ac5255dfa7f3ba52`, the merge of PR #520;
  - merge: `2163d68a5e713ff7151339aad22206cc55280e61`, that main merged into
    #573's branch at `c596af2bd3575ee0f96e7b7d543d410b1d634279`;
  - head: `1989a51d8af678cfb6c7449ef4ad8d32265c0927`, the merge's next commit
    (the review's tests, and #442's kernels numbering the static objects'
    symbols, in `c_check_program.c`);
  - probe: `d32d593fa04709bf2e28dd09ef19dd242b31b8be` (#573's head, merging
    main `74dae999734fa0423efcc198af2ebd6251cc8108`) with `probe.patch`.
- **Trees:** each tree on the host is the same files as `git archive` of its
  commit (the probe's with `probe.patch` applied), file by file by sha256.
- **Host:** `benchpress`, an AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, every
  run under the host's lock and pinned to CPU 2.
- **Compilers:** each tree built with `BUSTER_DEBUG_INFO=0 ./build.sh`
  (clang 23.1.1, `-O3 -march=native`):
  - main `e69a08f028e74f279ea1f5a414452e11bf8d0f13d4cb74cac4312f7b9a216709`;
  - merge `953034f9ee958c85676b4f8f863de95d24afc01dae25d6300232802da07c4105`;
  - head `0c77731866ada70424c85e86ca834568ba23ed44a1d182137adb5eec180fa9b6`;
  - probe `acdde149b135a252299cd798cda40ebba78c939d963b4daf0a7754f1f584b383`.
- **Source:** `sqlite/sqlite3.c` of the frozen corpus
  `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the
  host's default headers.
- **Date:** 2026-10-27, from 15:47:58 UTC.

## Commands

`ab.sh` (the A/B) and `probe.sh` (the probe) are the scripts, with every
command. The options are the first record's:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

- **Objects:** each build wrote the object by default and with `--scalar`;
  all six are the same bytes (`objects identical: 0c48ff92978c3125` in
  `run.log`), the first record's object.
- **Stages:** 15 rounds of `--time-stages`, each build once a round, in three
  holds of the lock of 5 rounds each. The script meant to rotate the order
  over all 15 rounds, but passed the hold's number as `bash -c`'s `$0`, so each
  hold ran the same five orders: each build ran first in 3 or 6 rounds, second
  in 3 or 6 and third in 3 or 6 (`stages.txt` keeps the order). `balanced/`
  repeats it with the order balanced, by `balanced/ab.sh`, the harness fixed:
  use that one for future captures.
- **Counters:** `perf stat -r 11 -e task-clock,cycles:u,instructions:u,branch-misses:u`
  of each build's default compile.
- **Graph run:** `benchmark-checker-source --passes 11 --only vector` of each
  build, twice, in turn: the graph run (`check_graph_run`) of the bodies'
  nodes alone, after both paths checked the whole unit and agreed
  (`comparison=identical`).
- **Probe:** `probe.patch` makes the graph run read every node's value at its
  end, as main's report scan did, when `BUSTER_PROBE_TOUCH_VALUES` is set. The
  one executable ran 30 rounds without it (`plain`) and with it (`touch`),
  beside main's build (`main`), in an order that rotates by round, three
  holds of 10 rounds each. Its object is the same bytes either way.

## Files

- `run.log`, `run-probe.log`: the scripts' own lines. exclusive.sh's
  messages about other holders of the lock are removed: they name other
  sessions' commands and links.
- `stages.txt`, `stages-probe.txt`: every `--time-stages` report, each line
  prefixed by its build.
- `stat-main.txt`, `stat-merge.txt`, `stat-head.txt`: perf stat's reports.
- `graph.txt`: the graph benchmark's summary lines.
- `build-*.log`: the builds' last lines.
- `probe.patch`: the probe, against `d32d593f`'s `c_checker.c`.
- `laptop/`: the laptop's per-function samples and its probe run (below).
- `balanced/`: the A/B repeated with the order balanced and the harness fixed,
  with a README of its own.
- `SHA256SUMS`: the files' hashes.

## Results

### Against main

Medians of the 15 runs of each build:

| stage | main | merge | change | `1989a51d` | change |
| --- | ---: | ---: | ---: | ---: | ---: |
| check-expressions | 20.396 ms | 15.822 ms | -4.574 ms (-22.4%) | 15.674 ms | -4.722 ms (-23.2%) |
| check-declarations | 5.161 ms | 5.500 ms | +0.339 ms (+6.6%) | 5.541 ms | +0.380 ms (+7.4%) |
| check-program | 15.947 ms | 12.088 ms | -3.859 ms (-24.2%) | 12.196 ms | -3.751 ms (-23.5%) |
| the clock's span | 158.008 ms | 149.616 ms | -8.392 ms (-5.3%) | 150.160 ms | -7.848 ms (-5.0%) |

- **Ranges.** check-expressions ran 20.274 to 20.862 ms on main, 15.555 to
  16.543 on the merge and 15.280 to 16.347 on `1989a51d`; check-program
  15.514 to 16.410, 12.034 to 12.253 and 11.864 to 12.298; check-declarations
  5.052 to 5.417, 5.388 to 5.614 and 5.461 to 5.831.
- **The other stages.** Each is within 0.2 ms of main's median, but
  `1989a51d`'s check-input: 65.977 ms against 65.476, though its code is the
  merge's, whose took 65.436.
- **perf stat:**

  | | main | merge | change | `1989a51d` | change |
  | --- | ---: | ---: | ---: | ---: | ---: |
  | task-clock | 158.86 ms | 150.31 ms | -5.4% | 149.92 ms | -5.6% |
  | cycles:u | 738.2 M | 690.2 M | -6.5% | 689.3 M | -6.6% |
  | instructions:u | 1,751.0 M | 1,555.3 M | -11.2% | 1,555.4 M | -11.2% |
  | branch-misses:u | 4.53 M | 4.29 M | -5.3% | 4.29 M | -5.2% |

- **Graph run, a body node:** main 55.6 and 55.7 ns (307.1 and 308.6
  cycles), the merge 41.0 and 40.9 ns (227.2 and 226.4 cycles), `1989a51d`
  40.9 and 40.2 ns (226.5 and 222.9 cycles). Main's vector path took 314,697
  of the 319,193 nodes through actions and folded 4,496 in vectors; the other
  two complete 147,114 without an action.

### check-declarations

Medians of the probe's 30 runs of each:

| stage | main | probe off | probe on |
| --- | ---: | ---: | ---: |
| check-expressions | 20.467 ms | 15.659 ms | 16.836 ms |
| check-declarations | 5.212 ms | 5.255 ms | 5.101 ms |
| check-program | 16.005 ms | 12.329 ms | 12.352 ms |
| the clock's span | 158.238 ms | 150.096 ms | 151.149 ms |

- **What main's scan left in the caches.** Main's report scan read every
  node's 96-byte value at the end of the graph run, the whole 33 MB column;
  #573's scans read the diagnostics' and contexts' bytes, and a value only
  where a node can report. Reading every value again (probe on, the same
  executable as probe off) took 1.177 ms more in check-expressions and
  0.154 ms less in check-declarations, whose initializers' and reports'
  checks read values next.
- **The rest.** With the probe off, the build of `d32d593f` took 0.043 ms
  longer than main in check-declarations. The merge's and `1989a51d`'s builds
  took 0.339 and 0.380 ms longer in the A/B, with the same scans: the rest of
  their increase came with those builds, not with the scans.
- **Ranges.** check-declarations ran 5.046 to 5.426 ms on main, 5.114 to
  5.394 with the probe off and 4.893 to 5.390 with it on.
- **The order.** Each of the three ran first, second and third in 10 rounds.

### The laptop's samples

`laptop/` attributes the increase on the owner's laptop, a Ryzen 9 7940HS
(Zen 4, Linux 7.3.0, clang 23.1.4), compiling SQLite 3.53.4's `sqlite3.c`
(sha256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`,
not the frozen file) with the same options and its own headers. Its builds
have debug information (`build.sh`'s default): main `a774acd2` (sha256
`267663fe30778f637b7ec9d1d660bffe6f170fa38b28d652e3189eb1e01c1eae`) and the
merge's working tree, which `2163d68a` committed two minutes later (sha256
`4e6501d575d601f3112994f1afb79d88f438af4dd066d1f919dfe90fe2dfcf5c`); and,
without it, the probe's (sha256
`7bf0c27ba888e4b638eb7a741e3b05afa808a5fba66ed1716b2d2449796c8d78`).

- **`stages-main-merge.txt`** (`stages-decl.sh`): 15 interleaved rounds,
  check-declarations 7.386 ms on main against 8.104 ms on the merge.
- **`cycles-by-function.txt`** (`perf-decl.sh`, `cycles:u` every 100,003,
  samples summed over 8 runs of each), **`instructions-by-function.txt`**
  (`perf-ins.sh`, `instructions:u` every 100,003, samples per run, the mean
  of 4 runs of each) and **`dram-fills-by-function.txt`** (`perf-fills.sh`,
  PMCx043's demand fills from DRAM, `cpu/event=0x43,umask=0x48/u` every
  1,009, summed over 4 runs of each): main's samples, the merge's and the
  difference, by function. check-declarations' functions
  (`check_initializers_run`, `check_init_value`, `check_init_objects_open`,
  `check_driver_reports`) ran the same instructions in both builds in more
  cycles, with no more demand fills from DRAM.
- **`stages-probe.txt`** (`stages-touch.sh`): 20 rounds of the probe's build
  without and with `BUSTER_PROBE_TOUCH_VALUES`: check-expressions 1.810 ms
  more with it, check-declarations 0.226 ms less.

## Limitations

- The caches were warm: every timed run followed a run of a build.
- Other sessions' and CI's jobs ran between the holds of the lock.
- The probe measures what the values column's warmth is worth within one
  executable. It doesn't measure the builds' placements: `time-runs` over
  shifted placements (buster's `docs/profiling.md`, "Comparing two
  versions") would.
- The laptop's numbers come from another CPU, another `sqlite3.c` and builds
  with debug information: they attribute the 9700X's increase, they don't
  time it.
- This is evidence for this source, workload, toolchain and machine only.
