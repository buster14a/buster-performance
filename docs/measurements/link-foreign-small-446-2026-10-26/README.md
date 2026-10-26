# link-foreign's small threaded dynamic PIE after #424: the 9700X requalification for #446

2026-10-26. [buster14a/buster#446](https://github.com/buster14a/buster/issues/446)
asked whether `link-foreign`'s 2,000-worker dynamic PIE on its threads slowed
from 2,437 to 2,543 µs (+4.4%) with #424, as its A/B measured over three
paired rounds ([#424's
record](https://github.com/buster14a/buster-performance/tree/421dfb22cf4f2aa53268b19e682b39401a07c40a/docs/measurements/main-c-homes-270-2026-10-25)).
This record repeats the case over many interleaved rounds, with main against
itself as a control, beside the controls the issue names and the sizes between
2,000 and 102,400 workers, and finds no regression: in 24 rounds in which each
build took each place in the order equally, the head's wall time was main's
within 0.6% (the rounds' medians and all runs alike), as close as main's own to
itself, and the 16-round campaign's +1.95% for the head was the order's.

## Executables and inputs

#424's archived builds on the 9700X (`BUSTER_DEBUG_INFO=0`), their sha256s
checked against #424's record before the runs:

- main `51ab0b63`, "base" (and "base2", the same executable again):
  `~/buster-fast-bench/build-270-claude/ab3/base/build/compiler`,
  `3d15d48fc37df41975cd51c08382f42d09ac1ae93f051b04c7a2767d0a39830a`;
- the head `6847c1db`: `~/buster-fast-bench/build-270-claude/ab3/head/build/compiler`,
  `93ecb1e647389e7f0be91e709b1f1d7c6aa5f42032143477197c740b8b82d8ef`.

#424 changed none of the linker's algorithms. What `link-foreign` runs
differently is the linkage of the linker modules' entry points
(`BUSTER_LINKER_ENTRY`: `import_object`, `executable_write` and the others,
each now compiled in one unit, its home, which the other units call),
`lane.c`'s thread context (one `_Thread_local` that `main.c`'s units share,
rather than a static one per unit), and where the code lies.

The inputs are `benchmark-link`'s programs that call libc, written as objects
by main's executable and kept (`--keep`): 2,000 workers in 10 units and 102,400
in 512, up to 8 filler instructions each, the programs #424's command linked,
and for the sizes between, 500, 1,000, 4,000, 8,000, 16,000 and 32,000
workers. `capture446.sh` ran #424's command once by main's executable under
`strace -f -e trace=execve`, which recorded the command lines `benchmark-link`
gives `link-foreign` (`link-foreign-commands.txt`); `capture446b.sh` kept the
2,000-worker program's objects, which the first run's 102,400-worker program
wrote over, and `capture446c.sh` the other sizes'. Their logs are in `links*/`.
AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1's builds, GCC 16.2.1's crt
objects and libgcc, glibc 2.44, transparent huge pages `always`.

## The harness

`procbench.c` (cc -std=c17 -O2), #445's harness, replays those command lines
verbatim, with each build's executable in place of `/proc/self/exe` and an
output of each label's own. It runs a list of commands in rounds that rotate
their order (round r starts at the list's command r - 1), each command's
warm-up and runs together, one round per hold of the shared lock, and keeps
each process's wall time, rusage (voluntary and involuntary context switches
among it) and counters (perf_event_open on the child from its exec, inherited
by its threads: task-clock, cycles, instructions, context switches, migrations
and page faults). As `benchmark-link` runs `link-foreign`:

- "its threads": `--lanes=8`, unpinned (procbench's own CPUs, all 15 online),
  where only CPU 2 has the performance governor and the others run powersave
  with `balance_performance`;
- "one thread": `--lanes=1`, pinned to CPU 2 (`benchmark-link` pins its
  one-thread runs to the first of `--cpus`, CPU 2);
- 41 runs after a warm-up with 20 ms before each for the 2,000-worker
  program (11 after 200 ms for 102,400 workers), `benchmark-link`'s default
  counts and pauses.

The effective clock below is cycles over task-clock, all threads: it counts
the time the lanes wait in `mwaitx` as running time without cycles, so it falls
both with the cores' clock and with the lanes' waits.

## Runs

- **The campaign** (`links446.list`, `campaign446.sh 1 16`): 16 rounds of 17
  commands: the 2,000-worker dynamic PIE on its threads by main, the head and
  main again (base2), and by main and the head the same on one thread, the
  static executable on its threads and on one, and 102,400 workers' dynamic
  PIE and static executable each way. Outputs on btrfs
  (`~/buster-fast-bench/perf-445-446-claude/links-out`), objects there too.
- **The sizes** (`sizes446.list`, from `sizes446.py`; `campaign446s.sh 1 4`):
  4 rounds of the dynamic PIE on its threads for 500 to 32,000 workers by
  main and the head, 21 runs after a warm-up each.
- **The phases** (`phases446.list`; `phases446.sh`, rounds 1 and 2, and
  `phases446b.sh 3 12`): the affected case by main, the head and main again
  with `link-foreign --time`, whose report each run kept (`out446p/`: each
  run's standard error, `ROUND-LABEL-RUN.err`; their standard output was
  empty and is left out), 12 rounds, so that each of the three runs in each
  place of the order four times.
- **As #424 ran it** (`tmpfs446.list`, `tmpfs446.sh 1 12`): the same three
  without `--time`, objects and outputs on tmpfs (`/tmp`, as #424's
  `--directory /tmp` had them), 12 rounds (`results446t.tsv`; the objects'
  sha256s, checked after the copy, in `tmpfs446-objects.sha256`).
- **The context switches** (`switches446.list`, `switches446.sh`): under one
  hold of the lock, `perf record -e context-switches -c 1 --call-graph
  dwarf,16384` of 22 links by main and 22 by the head (the threaded case,
  without `--time`, 20 ms apart; the first of each is left out), and
  `perf script`'s text of every switch (`switches-base.txt`,
  `switches-head.txt`); `analyze446s.py` classifies them by the kernel function
  that blocked and the innermost frame of the compiler or the C library.
- **The outputs** (`outputs446.sh`, `outputs-check.txt`): every case's last
  output by main and by the head, compared byte for byte and run, their exit
  statuses and output compared.

`analyze446.py` reads the campaign (`analysis.txt`), `analyze446_sizes.py` the
sizes (`analysis-sizes.txt`), `analyze446p.py` the phases
(`analysis-phases.txt`, from `results446p.tsv` and the reports in `out446p/`)
and the tmpfs runs (`analysis-tmpfs.txt`), and `analyze446s.py` the context
switches (`analysis-switches.txt`). Each script's log is beside it
(`campaign446.log`, `campaign446s.log`, `phases446.log`, `tmpfs446.log`,
`switches446.log`).

## Results

- **No regression.** Over the 12 balanced rounds with `--time`
  (`analysis-phases.txt`, 492 runs of each), the head's wall time differed
  from main's by +0.57% (the median of the rounds' changes, −5.67% to +5.79%)
  and −0.38% over all runs; main's from itself by +0.27% (−3.21% to +7.98%)
  and +0.35%. `link-foreign`'s own whole (`--time`, from its start to its release)
  was −0.57% for the head and −0.57% for main again. As #424 measured it,
  without `--time` and with the objects and outputs on tmpfs
  (`analysis-tmpfs.txt`, 12 balanced rounds of 41 runs), the head differed by
  −0.19% (−2.81% to +5.22%) and +0.24% over all runs, and main from itself by
  +0.39% (−2.43% to +4.67%) and +0.27%; a link took 2.46 ms there, against
  2.65 ms with its output on btrfs and its `--time` report.
- **The campaign's difference was the order.** In 15 of the campaign's 16
  rounds, main ran right after the 12 one-thread links of the 102,400-worker
  static executable (about 3 s in which only CPU 2 worked), the head right after
  main's small threaded links, and main again right after the head's. The
  head measured +1.95% over all runs (the median of the rounds' changes +2.45%,
  −4.00% to +11.62%) and main again +1.58% (+1.68%, −3.99% to +7.19%): both
  later places were slower, by the same amount within the spread.
- **The same work, at another clock.** The head ran 21.77 M instructions
  against main's 21.73 M (+0.2%), and the outputs are byte-identical
  (`outputs-check.txt`). In the campaign, the quarter of the affected case's
  runs with the lowest effective clock (2.10 GHz) took 2,747 µs with 29.1 M
  cycles, and the quarter with the highest (2.71 GHz) 2,331 µs with 32.0 M:
  the slower runs took fewer cycles, not more, at a lower clock. The cores but
  CPU 2 sit idle in the 20 ms before each run and wake slowly (the linker
  design's "How long to wait before sleeping"), where a one-thread run on
  CPU 2 runs at an effective 4.8 GHz.
- **The process around the link** took 0.65 ms of a run's 2.65 ms, in both
  builds (the wall time less `--time`'s whole: 0.650, 0.660 and 0.650 ms):
  the process's start before `link-foreign`'s first stage and its end after
  the last.
- **Context switches.** The head's processes took more voluntary context
  switches: in the campaign 48 against main's 40.5 (and main again's 42) in
  the affected case and 49 against 41 in the static executable's, in the
  balanced rounds 44 against 41 and 41. In every build alike, the runs with
  more switches (cut at each build's median) spent 0.09 ms more in the
  resolution, its opening of the inputs and its archive indices among it, and
  took 0.15 ms longer. perf recorded where they happen (`switches446.sh`,
  `analysis-switches.txt`: every context switch of 21 processes of each
  build, with kernel and user call chains). Per process, the lanes' threads
  waited 11 to 12 times in page faults for a page-cache folio another thread
  was mapping (`filemap_fault`) and 15 to 16 times for the address space's
  lock, in their page faults and in their `mmap`, `madvise` and `munmap`
  calls, and the main thread 6.4 times in `pthread_join`; no lane slept at a
  sync. These are the costs of eight threads starting at once in a new
  process, faulting the same pages and reserving their stacks and scratch
  arenas, and of their ends: `link-foreign` starts a cold group of eight lanes
  for each of its resolution, conversion and write (`lane_run` outside a
  command-owned team, #306), 21 threads started and joined per link, each
  reserving and releasing its scratch arenas. With perf attached, the head
  took fewer than main: 35.3 against 38.7.
- **The controls** (the campaign; all runs, then the median of the rounds'
  changes): the same link on one thread −0.91% (−1.38%); the static executable
  on its threads +0.63% (+0.45%) and on one −0.45% (−0.42%); the 102,400-worker
  dynamic PIE on its threads +0.36% (+0.39%) and on one +0.49% (+0.36%), and
  its static executable +0.08% (+0.21%) and −0.73% (−0.66%).
- **The sizes** (`analysis-sizes.txt`, four rounds of 21 runs): the dynamic PIE
  on its threads changed by +2.40% at 500 workers (the rounds −1.95% to
  +4.56%), −2.20% at 1,000 (−7.72% to +5.06%), −0.49% at 4,000, −1.08% at
  8,000, −0.67% at 16,000 and −0.34% at 32,000: no knee. The links up to 1,000
  workers ran at an effective 2.1 to 2.4 GHz, and from 4,000 up at 3.1 to
  4.0 GHz: the longer a link, the more of it runs after its cores' clocks
  have risen.

## The decision

A non-regression: no fix. #424's +4.4% came from three rounds whose spread,
for this case, is that of main against itself. A small link on its threads
runs at the clock its cores woke into, which the order of the commands and
what ran before them decide by several percent: such a comparison needs main
against itself in the same rounds, and an order in which each build takes each
place equally. Apart from #424, `link-foreign` pays for three cold lane groups
per link, which a command-owned team (#306's) would start once.

## Limitations

- The lock's messages ("exclusive.sh: waiting" and their title, link and pull
  request lines, which name other sessions) were removed from the logs.
- `procbench` was rebuilt at 17:12 UTC, before the campaign's first round,
  with a larger limit on a command's arguments (a 102,400-worker command line
  has 512 objects); `procbench.c` here is the rebuilt one.
