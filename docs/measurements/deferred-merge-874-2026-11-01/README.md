# The deferred merge's fresh pages, 2026-11-01

The 9700X's measurements for Buster's issue [#874](https://github.com/buster14a/buster/issues/874) and
the fix merged as PR [#986](https://github.com/buster14a/buster/pull/986). The merge's pass writes the
merged binding stream's eight columns, and the token positions its scans fill, into the caller's scratch
arena from every lane that read the bodies. In a process's one reading those are fresh pages, and lanes
that write one 2 MB region at first touch each allocate and clear a huge page for it, of which the kernel
maps one, as in #764's race in the walks. The benchmark reused the caller's arenas from reading to
reading, so its timed merge passes faulted pages the first pass had already mapped; that is why #764's and
#847's campaigns could not see this race (issue #874).

The fix, in main as `6ebfff86`/PR #986, faults in exactly the written ranges on the calling thread before
the merge's `lane_run`: the six 4-byte columns, the operation and kind bytes, and the positions, one
store per 2 MB region, each overwritten by the pass. It adds no per-write protocol to the pass, and the
one-lane path is unchanged. `benchmark-checker-deferred --cold` releases and reserves the caller's arenas
for every reading, so a process's one reading is measured.

The record has two campaigns on the 9700X:

- **E2**: seven units read cold on up to eight lanes by the rule, six passes, with every page fault
  recorded with its time, instruction and address, for the fix and for the same tree with the fault-in's
  body empty (the control). No 2 MB region of the merge's pass took a store fault from two threads at
  once with the fix; the control took them at 7 regions of `h16x77.c`, 12 of `h16x154.c` and 11 of
  `sqlite3.c`, and none on the other four.
- **G**: A2's 43 units, five rounds, cold, the fix against the control by each tree's rule on up to eight
  lanes. No unit's five-round median is more than 2% slower; the all-unit median is 1.27% faster, and the
  31 units the rule gives more than one lane are 5.03% faster by the median (19.09% faster to 1.39%
  slower).

## Sources and inputs

| Tree | Buster source | Files under `src` | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `fix` | main `97824e90`, with #986's `check_deferred_fault_range` and `--cold` | 706 | `617f8fa87720f1eef377eda6e3fae31bbab2aabd0d9a3fe7b70fbb43f0f51a61` |
| `control` | the same tree with the fault-in's body emptied (`patches/control.diff`) | 706 | `80a20b34a9a7d6d65e91b9bab414579fa341e0dfbd18bfdd1de0d9ffaa3d5610` |

`trees.txt` has each tree's commit and manifest hash. Each tree was built as the 9700X job builds it,
`env BUSTER_DEBUG_INFO=0 ./build.sh`, a lock hold each (`logs/build-fix.txt`, `logs/build-control.txt`,
`binaries.sha256`). `fix` is the reviewed source; `control` changes only the body of
`check_deferred_fault_range`, so the merge runs exactly as the pre-fix tree's did while the `--cold`
measurement and every other later change stay in both trees.

The inputs are record A2's 43 units (`inputs.sha256`, the same files and SHA-256 as #764's and #847's
records): four of c-testsuite's single-exec programs at `5c7275656d751de0e68b2d340a95b5681858ed07`, the
frozen `sqlite3.c` and 38 synthetic units from A2's generator (`gen2.c`), read with the frozen corpus's
pinned predefines and headers (`scripts/env.sh`); `SOURCE_DATE_EPOCH=1792454400`; `CPATH` and
`C_INCLUDE_PATH` unset.

Each gate run is record A2's command,

```sh
./build/compiler benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 --cold [the options] FILE
```

with `--passes 12` for `sqlite3.c`, in a process of its own, the fix and the control in the same batch,
their order rotating by round. A batch of five units held the lock once; a round's batches are in
`logs/G-cold.txt` (`scripts/queue.sh`, `scripts/batch.sh`, `scripts/runs.sh`).

Host (`host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1, perf 7.2.9-1;
transparent huge pages `always` (defrag `madvise`, the huge zero page in use); CPU 2 performance, the
other CPUs powersave.

## Campaign E2: the merge's columns

`scripts/e2-run.sh`, `scripts/e2-batch.sh` and `scripts/e2-one.sh`: seven units, the fix and the control,
cold, by the rule on up to eight lanes, six passes, a lock hold for the batch: a process under `perf stat`
(task-clock, page faults, user and kernel cycles; `perf/stat-*.csv`) and one whose every page fault was
recorded with its time, instruction, symbol and address (`perf record -T -e page-faults -c 1 -d`;
`perf/faults-*.txt.gz`). `scripts/e2ops.py` classifies each fault's instruction as a store when its last
operand is memory (a read-modify-write too, but not a compare or test); `scripts/e2summary.py` and
`scripts/e2merge.py` count, per unit and tree, the 2 MB regions where more than one thread took a store
fault at one 4 KB page each within 100 µs: a huge page's first write. A region of base pages has a thread
faulting several pages there, which is not this race.

| Unit | Fix pass stores | Fix regions | Control pass stores | Control regions |
| --- | ---: | ---: | ---: | ---: |
| `b16x77.c` | 114 | 0 | 114 | 0 |
| `h16x77.c` | 120 | 0 | 151 | 7 |
| `l16x38f384.c` | 78 | 0 | 78 | 0 |
| `h16x154.c` | 204 | 0 | 264 | 12 |
| `h16x10.c` | 36 | 0 | 36 | 0 |
| `l16x19f192.c` | 67 | 0 | 68 | 0 |
| `sqlite.c` | 660 | 0 | 690 | 11 |

The fix's pass stores are the calling thread's fault-in stores and the pass's own writes to pages already
mapped; its lanes take no store fault at a region another thread is clearing. The control's seven,
twelve and eleven regions are the race itself: the lanes' stores in `check_deferred_pass_items` meet a
fresh huge page together. The other units' passes are below the arena's huge pages or have too few events
for their lanes to meet in a region; they show none in either tree.

The same processes' counters (`perf/stat-*.csv`): the fix takes 12.8% to 35.5% fewer of the kernel's
cycles on the units whose lanes raced (b16x77 284.0 against 434.8 Mcycles, h16x77 305.4 against 473.7,
l16x38f384 253.2 against 332.1, h16x154 510.9 against 733.8, sqlite 1746.4 against 2002.4), and the same
within 3.5% on h16x10 and l16x19f192, which show no race. The user instructions are the same in both
trees to 0.02% (largest difference, l16x19f192's 0.018%).

## Campaign G: the gate

A2's 43 units, five rounds, the fix against the control by each tree's rule on up to eight lanes, cold
(`logs/G-cold.txt`, `tables/G-cold.txt`). The five-round medians, fix against control:

- all 43 units: median 1.27% faster, from 19.09% faster to 1.39% slower; no unit more than 2% slower;
- the 31 units the rule gives more than one lane: median 5.03% faster, from 19.09% faster to 1.39%
  slower;
- the 12 units it reads on one lane: median 0.59% faster, from 1.64% faster to 1.38% slower.

Four units had one round above 2% slower: `b16x19.c` 2.05%, `h16x10.c` 5.31%, `h2x320.c` 2.82% and
`l16x10f192.c` 3.06%. Their five-round medians are 1.39% slower, 2.17% faster, 0.48% faster and 0.51%
slower: the spread of two builds of one code is about 2% (`docs/profiling.md`, "Comparing two versions"),
and h16x10 and l16x19f192 are E2 units with no race region in either tree, where the fix's path is the
one-lane path or absent. b16x19 is an eight-lane unit whose median is the 1.39% slower above; the other
two are not E2 units.

The raw outputs are `logs/G-cold.txt`; each reading's heading names its round, tree, unit and lanes, and
every benchmark exit status is 0.

A state's later readings reuse the caller's arenas, so the merge's columns are already mapped and the fix
pays only its nine stores a reading. One warm round over all 43 units (`logs/G-warm-full.txt`,
`tables/G-warm.txt`), the fix against the control, is 0.57% faster by the median, from 5.15% faster to
2.40% slower (`h16x38.c`, whose cold median is 19.09% faster); that is one round, not the cold gate's
five, and the outlier is within the one-round spread of two builds.

## What the fix changes

On the units whose lanes raced, the fix removes the huge-page clears the kernel did once per region per
racing lane: E2's control took two-thread store faults at 30 regions across `h16x77.c`, `h16x154.c` and
`sqlite3.c`; the fix took none, and its processes took 12.8% to 35.5% fewer kernel cycles. Its cold gate
is 1.27% faster across A2's 43 units and 5.03% faster across the multi-lane ones, with no unit's median
more than 2% slower. The fault-in is one store per 2 MB region on the calling thread, so the warm path
and one-lane readings pay only those stores; the benchmark's reused pages are already mapped.

The implementation and documentation are original project work. Clang is run externally as an oracle; no
compiler implementation or external test corpus is copied into this change.
