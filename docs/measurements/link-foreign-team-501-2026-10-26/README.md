# link-foreign's stages on one team of threads: #501 on the 9700X

2026-10-26. [buster14a/buster#501](https://github.com/buster14a/buster/issues/501)
asked that `link-foreign` start one command-owned lane team for its
resolution, conversion and write, where it started and joined a cold group of
threads for each (on eight lanes, 21 threads started and joined per link,
each reserving and releasing its scratch arenas); that measurements decide
whether the team's workers keep their scratch arenas across the command's
operations; and that the change be measured against main with 1, 2,000 and
102,400 workers, dynamic and static, on its threads and on one lane, by whole
processes' wall time, context switches and `--time` phases, with main timed
twice in the same rounds in an order where each build takes each place
equally ([#446's record](https://github.com/buster14a/buster-performance/tree/1ee59a26fdbcd7b5dabe31eb7c24f5bf81a96c3b/docs/measurements/link-foreign-small-446-2026-10-26)).

The final head (the team, its workers keeping their scratch arenas) links on
eight lanes 6.8% to 17.7% faster than main, and on one lane as fast as main,
within main's spread against itself:

| Program, 8 lanes | main µs | main again | final head | head / main, paired [95%] | main again / main |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1 worker, dynamic PIE | 1,900 | 1,881 | 1,731 | −10.41% [−12.34, −8.30] | −0.57% |
| 1 worker, static | 3,271 | 3,317 | 3,041 | −7.09% [−8.17, −5.35] | +1.24% |
| 2,000 workers, dynamic PIE | 2,699 | 2,730 | 2,227 | −17.65% [−19.02, −15.16] | −0.01% |
| 2,000 workers, static | 3,944 | 3,949 | 3,474 | −12.27% [−13.12, −11.37] | −0.20% |
| 102,400 workers, dynamic PIE | 31,940 | 31,826 | 28,920 | −8.77% [−9.98, −7.10] | −0.37% |
| 102,400 workers, static | 32,454 | 32,305 | 30,324 | −6.77% [−7.40, −5.26] | −0.42% |

(The confirmation campaign below: medians of 240 runs each, 54 for 102,400
workers; the change is the median of the runs' changes, each run against
main's in the same round, with its bootstrap interval.)

## Executables and inputs

Built on the 9700X as its CI job builds (`BUSTER_DEBUG_INFO=0 ./build.sh`),
each under its own hold of the shared lock (`build501.sh`,
`confirm/queue501c.sh`); sha256s in `builds501.sha256` and
`confirm/builds501c.sha256`, and every source file's in `manifests/`:

- **v0**, main [`5a5bcd33`](https://github.com/buster14a/buster/tree/5a5bcd33089c0590a632649d104041ee113f41be):
  `602d5270842795d989ebb3ae54e1ce774104c28bbc0aad0435ff59c24707988e`. Its tree
  is the commit's, file for file (`manifests/v0.sha256`).
- **v1**, the head with the team, its workers releasing their scratch arenas
  after each operation, as every team's then did: `80480a376403805f8cfe3ca85fe8f6a5573768ebe00e620c51c06eb130f602d9`. Its
  sources and `build.sh` are [`0a76ec09`](https://github.com/buster14a/buster/tree/0a76ec098e8be1f567ccb82634ca7f7555a9a1e0)'s;
  three documentation files are those of a documentation commit after it that
  was amended before the branch was pushed (`ad9fc555`, which `build501.sh`'s
  comment still names), and nothing the build reads.
- **v2**, v1 with `switch501.patch`, for the measurement alone: the workers
  keep their scratch arenas, emptied, across operations when
  `BUSTER_501_SCRATCH` is `keep`, and release them after each otherwise:
  `1e6043197cae8812f9c58b8474d557ec728a3642399a8a3dd15ed84efc6614a7`. One binary, so the two settings share their layout.
- **v3**, the final head [`dea39785`](https://github.com/buster14a/buster/tree/dea397852d17112bd1ffecb74eb87a605c48a850):
  `lane_team_keep_scratch`, which `link-foreign`'s team calls:
  `0bf0718c4b104e3f94235da3a45e545eef601927c0cbc2f6c89135752ea30694`. Its tree is
  the commit's, file for file.

The inputs are `benchmark-link`'s programs that call libc, written as objects,
linked by the command lines `benchmark-link` gives `link-foreign` (#446's
`capture446.sh` traced them): 2,000 workers in 10 units and 102,400 in 512,
up to 8 filler instructions each, #446's kept objects
(`~/buster-fast-bench/perf-445-446-claude/links2000` and `links`); and one
worker in 4 units (`benchmark-link` writes at least 4), which v0's
`benchmark-link --functions 1 --only linkers --linkers link-foreign --kinds
dynamic,static --runs 1 --keep` wrote (`links1.log`). AMD Ryzen 7 9700X,
Linux 6.18.50-2-lts, clang 23.1.1's builds, GCC 16's crt objects and libgcc,
glibc 2.44, transparent huge pages `always`. Objects and outputs on btrfs.

## The harness and the lists

`procbench.c` is #446's harness with one option more, `var=NAME=V`, an
environment variable for the child: every command gets
`BUSTER_501_SCRATCH`, `free` or `keep`, so that each has an environment of the
same size, and each case's executables' and outputs' paths have the same
length across its variants. Each list (`lists501.py`, `confirm/lists501c.py`)
holds one command per variant and case, run once per round with 20 ms before
each run (200 ms for 102,400 workers, `benchmark-link`'s pauses), the
variants outermost, so that a command follows its own variant's previous case,
and procbench's rotation starts each round one command later. Each
procbench call's first round is left out as its warm-up. The threads' runs
are `--lanes=8`, unpinned (all 15 online CPUs; only CPU 2 has the performance
governor); the one-lane runs `--lanes=1` pinned to CPU 2, as `benchmark-link`
runs them. Each run keeps its wall time (from the child's release to
`wait4`'s return), rusage (voluntary and involuntary context switches among
it) and counters of the child and every thread it starts (task-clock, cycles,
instructions, context switches, migrations, page faults); the `--time` lists'
runs also their reports (`out501/ROUND-LABEL-0.err`; their standard output was
empty and is left out).

## Runs

- **The first campaign** (`queue501.sh`: `build501.sh`, `lists501.py`, then
  `campaign501.sh 8`, eight passes of `pass501.sh`, each under one hold of
  the lock, about 70 to 80 s, 20 s apart): main twice (m1, m2: v0), the head
  (hd: v1) and the switch build releasing (rl) and keeping (kp) its workers'
  scratch arenas. Each pass ran `small-threads` (1 and 2,000 workers, both
  kinds, on eight lanes, 41 rounds) and `big-threads` (102,400 workers, 10),
  and every other pass `small-one` and `big-one` (one lane: m1, m2 and hd),
  or `small-time` and `big-time` (the threads' lists with `--time`). Results
  in `results501-LIST.tsv`; `analyze501.py` gives `analysis501.txt` and
  `analyze501b.py` the pass-by-pass changes and their bootstrap intervals,
  `analysis501-passes.txt`.
- **The context switches** (`switches501.sh`, after the campaign, one hold):
  `perf record -e context-switches -c 1 --call-graph dwarf,16384` of 22 links
  each of the 2,000-worker dynamic PIE on eight lanes by m1, hd and kp, 20 ms
  apart, and `perf script`'s text of every switch (`switches-LABEL.txt`);
  `analyze501s.py` (#446's `analyze446s.py`) classifies them by the kernel
  function that blocked, leaving out each first process
  (`analysis501-switches.txt`).
- **The system calls** (`syscalls/`, on the laptop, a Ryzen 9 7940HS, Zen 4):
  `strace -f -c` of one link each, five times, of a 2,000-worker program that
  the head's `benchmark-link` wrote there, by main, the head and the switch
  build's two settings (`syscalls501.sh`, `syscalls501.txt`). The counts are
  the same on every run but futex's.
- **The confirmation** (`confirm/`: `queue501c.sh 6`, the final head v3's
  build, `lists501c.py`, six passes of `pass501c.sh`): main twice (m1, m2) and
  the final head (fn), the same lists, but each variant's block now starts
  with a warm-up command (`w...`, its 1-worker dynamic PIE, left out), so
  that every measured command follows a run of its own executable (see
  "Limitations"). `analysis501c.txt` and `analysis501c-passes.txt`.

## Results

- **The team** (first campaign, head against main, paired, over 320 rounds,
  or 72 for 102,400 workers; main again against main in brackets): the
  2,000-worker dynamic PIE −13.51% (+0.79%), its static executable −9.40%
  (+0.34%), the 1-worker static executable −8.17% (−0.78%), and 102,400
  workers −6.85% (−0.18%) and −5.51% (+0.40%); every pass's change on the
  same side (`analysis501-passes.txt`). On one lane, which starts no team, the
  head is main within ±1.1%, its instructions the same.
- **The confirmation** (the table above) agrees, the final head's scratch
  arenas kept: `analysis501c-passes.txt` has each pass. Its one-lane runs are
  main's within ±1.9%, main against itself within ±4.0% (the 2,000-worker
  dynamic PIE's −4.03% is main's second run against its first).
- **Where the time goes** (`--time`, the confirmation's medians in ms, main
  then the final head): the 2,000-worker dynamic PIE's whole 2.109 to 1.741:
  the team's start (the new `lanes` stage) 0.118, the resolution 0.903 to
  0.605 (its `open` 0.131 to 0.069), the conversion 0.516 to 0.365 (its
  `sections` 0.169 to 0.092), the write 0.542 to 0.361 (its lanes' start and
  symbol selection 0.065 to 0.010), the release 0.138 to 0.251 (the team's
  stop and the workers' arenas). At 102,400 workers the stages' own phases
  ran faster too: the conversion 10.17 to 8.57 (`check` 2.26 to 1.63,
  `sections` 1.55 to 1.22), the write 7.83 to 6.67 (`chunks` 6.37 to 5.76).
  The effective clock (cycles over task-clock, every thread) rose from 4.36 to
  4.58 GHz, and the CPU time fell from 216 to 200 ms. That is consistent with
  the workers staying on cores that are awake, where a cold group's new
  threads started on idle ones (the linker design's "How long to wait before
  sleeping"), but the record has no clock per core, so it doesn't separate
  the clocks from the threads' waits and scheduling.
- **Context switches**: voluntary ones per process (rusage, the
  confirmation's medians) rose on the small links, 48 to 52, 50 to 58, 53 to
  61 and 53 to 64, and fell at 102,400 workers, 152 to 106 and 112.5 to 94.
  The recording (`analysis501-switches.txt`, per process, by the kernel
  function that blocked, all frames together; main, the head, and kept) shows
  why: the team's workers sleep on futexes between stages and until the team
  stops, about 28 to 32 times per link (`futex_do_wait` from `syscall`: 1.1,
  32.0, 28.0), where main's threads ended; and the waits the issue counted
  fell: for a page-cache folio, 20.7 to 15.6 (9.0), for the address space's
  lock in page faults (`rwsem_down_read_slowpath`) 13.5 to 9.9 (5.6), and the
  main thread's futex waits inside the C library, its `pthread_join`s (perf
  gives those frames no symbol), 6.2 to 1.1 (2.1). Waits for the lock's
  write side, in `mmap`, `madvise` and `munmap`, went from 10.5 to 7.7, and
  10.6 kept: 3.9 of those are `munmap`s in each process's last tenth, the
  workers unmapping their kept arenas together when the team stops. 15 to 19
  of main's threads switched per process, 8 of the head's.
- **System calls** per link (`syscalls/syscalls501.txt`, the laptop's
  2,000-worker program on eight lanes): `clone3` 21 to 7; `mmap` 92 to 86,
  `munmap` 74 to 68 and `madvise` 114 to 94 for the dynamic PIE (84, 66, 116
  to 78, 60, 96 for the static executable); keeping the scratch arenas 14
  `mmap`s, 14 `munmap`s and 28 `madvise`s fewer still: each of the seven
  workers' reservation of a scratch arena in the conversion and again in the
  write (a reservation is an `mmap` and two `madvise`s).

- **The outputs** (`outputs501.txt`): each case's last output by every
  command of both campaigns, main's, the head's, the switch build's in both
  settings and the final head's, on eight lanes and on one, has one sha256.

## The decision: the workers keep their scratch arenas

The switch build's two settings, one binary, paired over the first
campaign's rounds (`analysis501-passes.txt`, kp against rl): the 2,000-worker
dynamic PIE −2.55% [−4.02, −0.32], its static executable −2.52% [−3.45,
−1.43], the 1-worker static executable −2.66% [−3.89, +0.14], 102,400 workers
−0.67% [−1.12, −0.02] and −0.68% [−1.31, +0.24]; 28 to 47 page faults and
0.9 to 2.4 M instructions fewer per link. Its cost is memory: the arenas'
pages stay until the team stops, in which the workers then unmap them
(`--time`'s release 0.17 to 0.25 ms on the 2,000-worker dynamic PIE), and the
peak resident set of the 2,000-worker static executable grew by 1.9 MB
(45,152 to 47,070 KB), the others' by under 0.3 MB. `link-foreign`'s team keeps
them (`lane_team_keep_scratch`); the benchmarks' teams release them as before.

## Limitations

- In the first campaign, each variant's first case (the 1-worker dynamic PIE
  on eight lanes, and on one lane) ran right after another variant's
  executable, and the variants whose predecessor there was their own
  executable ran faster: main's second run (after main) by 5.2% against main's
  first (after the switch build), and kp (after rl, the same binary) by 5.7%
  against rl (after the head). The first campaign's changes for that case
  aren't comparable; the other cases follow their own executable's previous
  case, and their main-against-main controls are within ±0.8%. The
  confirmation puts a warm-up command of each variant's executable before its
  block. Even there, once per cycle of procbench's rotation (every 15 rounds,
  9 in the 102,400-worker lists), when a round starts at a block's first
  measured command, that command follows another executable.
- The executables' layouts move the peak resident set by about 1.3 MB: v2's
  release setting runs v1's code and peaked 1.25 to 1.39 MB above v1 in every
  case of the first campaign, and on one lane, where no team runs, v3 peaked
  1.24 to 1.37 MB above v0, with 8 to 10 fewer page faults. That is
  consistent with a transparent huge page in the 242 MB `.bss`, whose start
  each build places differently (0x2430f00 to 0x2433a80), not with their
  code. Peak resident sets of different executables compare only beyond that
  margin: the final head's on eight lanes is 0.3 to 3.4 MB above main's
  (`analysis501c.txt`).
- The confirmation measures the final head; the decision on the scratch
  arenas comes from the first campaign's switch build. The system calls were
  counted on the laptop (Zen 4), under `strace`, whose own cost is in no
  timing here.
- The lock's messages ("exclusive.sh: waiting" and their title, link and pull
  request lines, which name other sessions) were removed from the logs; the
  harness's error logs held nothing else and are left out, as is the context
  switch recording's empty output.
- `analyze501.py` and `analyze501b.py` ran on the laptop over copies of the
  results; `analyze501.py` here is the version that also reads the
  confirmation's labels (fn, and the warm-ups it leaves out).
