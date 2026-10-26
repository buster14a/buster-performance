# The checker benchmark's slow processes: the stack's page offset, for #445

2026-10-26. [buster14a/buster#445](https://github.com/buster14a/buster/issues/445)
asked what made `benchmark-checker-source`'s body checking intermittently
3.6–15.7% slower in #424's A/B ([its
record](https://github.com/buster14a/buster-performance/tree/421dfb22cf4f2aa53268b19e682b39401a07c40a/docs/measurements/main-c-homes-270-2026-10-25)):
in six of the head's nine processes and in about one of main's thirteen, at the
same clock. This record has the answer: the page offset at which Linux puts a
process's initial stack, which address space randomization draws per process,
in main and in #424's head alike. At the slow offsets the processes take more
store-to-load conflicts, consistent with the checker's stack slots sharing
their low 12 bits with the data it stores (4K aliasing), though the record
doesn't identify the loads and stores ("More store-to-load conflicts").

## Executables and inputs

#424's archived builds on the 9700X (`BUSTER_DEBUG_INFO=0`), their sha256s
checked against #424's record before the runs:

- main `51ab0b63`, "base": `~/buster-fast-bench/build-270-claude/ab3/base/build/compiler`,
  `3d15d48fc37df41975cd51c08382f42d09ac1ae93f051b04c7a2767d0a39830a`;
- the head `6847c1db`: `~/buster-fast-bench/build-270-claude/ab3/head/build/compiler`,
  `93ecb1e647389e7f0be91e709b1f1d7c6aa5f42032143477197c740b8b82d8ef`.

Both paths have the same length, so the same environment puts both
executables' stacks at the same offset. The input is the frozen SQLite source
of the preprocessor oracle's corpus (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`,
`sqlite3.c` sha256 `0a409f16…f5e23d`) with #424's options (the lists have
them). AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages
`always`, every process pinned to CPU 2.

## The harness

`procbench.c` (cc -std=c17 -O2) runs a list of commands in rounds that rotate
their order, one round per hold of the shared lock, and keeps each process's
wall time, rusage, counters (perf_event_open on the child from its exec,
inherited by its threads), its `AnonHugePages` and its initial stack's address
(`/proc/PID/stat`'s startstack) read while it runs, and its output. `norandom`
runs the child without address space randomization (`personality(ADDR_NO_RANDOMIZE)`,
as `setarch -R`), and `pad=N` adds an environment variable of N bytes, which
moves the initial stack down by N + 23 bytes (its string, its NUL and its
pointer), rounded up to 16.

## Runs

- **The campaign** (`checker445.list`, `campaign445.sh 1 16`): 16 rounds of
  four processes, main and the head each with randomization and without, the
  benchmark as #424 ran it (21 passes of 4 iterations), with cycles,
  instructions, task-clock, dTLB walks (`rf045`) and L2 data misses (`r0864`)
  beside the benchmark's own counter. `out445/` has each process's output.
- **The sweep** (`sweep445-0.list` to `sweep445-3.list`, `sweep445.sh 2`):
  without randomization, the environment padded by 64k + 50 bytes for k from 0
  to 63, which puts the initial stack at every 64th byte of its page, by both
  executables, twice; `--only scalar --passes 7` to keep a process near a
  second; with cycles, instructions, dTLB walks and store-to-load conflicts
  (`r0224`, `ls_bad_status2.stli_other`). `out445s/`.
- **The driver's sweep** (`driver445-0.list`, `driver445-1.list`,
  `driver445.sh`): the C driver's `-fsyntax-only` of the same source with the
  same 64 paddings, three processes each, by both executables. Its arguments
  put its stack 32 bytes further into the page than the benchmark's: its
  offsets are 48 to 4,080 bytes, every 64th, where the sweep's are 16 to
  4,048.

`analyze445.py` reads the campaign (`analysis-campaign.txt`), and
`sweep445.py` both sweeps (`analysis-sweeps.txt`).

## Results

- **The offset decides, and both builds share it.** In the sweep, body
  checking ran 3 to 13% slower at seven of the sampled offsets from 208 to 656
  bytes into its page (all but 528, which ran at the fast offsets' speed), 4%
  at 2,832, and 1.5–2% at 1,232 to 1,296 and 3,088; elsewhere
  it ran at 49.3–49.9 ns per node. Main and the head have the same slow offsets
  with the same slowdowns, in both sweeps (8 of 64 offsets each over 2%).
- **More store-to-load conflicts.** At those seven offsets from 208 to 656
  bytes into its page the processes took 95 to 121 million store-to-load
  conflicts (`ls_bad_status2.stli_other`, loads that couldn't complete for an
  older store), and at 2,832 about 88 million, against 77 to 84 million at the
  other offsets (91 at one), with the same instructions, dTLB walks (29,000 to
  32,000 in the slow processes, a median of 30,400 in the others) and 1.2 GB of
  huge pages in every process. That is consistent with loads whose addresses
  share their low 12 bits with older stores' (4K aliasing between the stack
  slots and the data the loop stores) waiting on them, but the event counts
  every load that couldn't take an older store's data, and this record doesn't
  identify the loads and stores (an IBS sample of their addresses would).
- **Its incidence.** In the campaign's 32 randomized processes, 8 were over 2%
  slower, four of each build, each with its stack in or beside the sweep's
  bands: main at 368, 384, 640 and 1,200, the head at 192, 272, 640 and 2,800.
  Without randomization (the stack at 2,128 with the harness's environment) all
  32 ran at 49.45–50.24. So 8 of 32 randomized processes were slowed in this
  campaign, in either build: #424's six of nine for the head was an uneven
  draw (about 1% likely at that rate), not a property of its code.
- **The whole driver doesn't feel it.** `-fsyntax-only` of the same source
  took 148.4–151.5 ms (main) and 149.3–152.1 ms (the head) over its own 64
  offsets (each 32 bytes past one of the sweep's), median 150.0: body checking is about a tenth of the driver, run once, where
  the benchmark repeats it 84 times in a process.

## The decision

No fix for #424: its head has main's slow offsets and slowdowns, and the
driver varies by at most 1.5% over its own sweep of offsets. The benchmark's
per-process spread is a measurement hazard: compare its medians over many
processes, or fix the offset (`setarch -R` with the same argument and
environment bytes, as `procbench`'s `norandom` and `pad` give them, each
process's startstack checked) and compare builds at several offsets. Removing
the conflicts at their source (which loads wait on which stores, 4K aliasing or
not) would be a change to the checker's body loop of its own.

## Limitations

- What the conflicts are: see "More store-to-load conflicts". A comparison at
  one offset needs both builds' processes at that offset, which the same
  argument and environment bytes give (the two executables' paths here have
  the same length) and `/proc/PID/stat`'s startstack, which `procbench`
  records, confirms.
- The sweep's resolution is 64 bytes; the campaign's 16-byte offsets show the
  bands a little wider than the sweep (192 and 2,800 are slow, at their edges).
- The lock's messages ("exclusive.sh: waiting" and their title, link and pull
  request lines, which name other sessions) were removed from the logs.
- `procbench` was rebuilt at 17:12 UTC, between the campaign's rounds 3 and
  4, with a larger limit on a command's arguments (for #446's lists), which
  changes nothing it measures; `procbench.c` here is the rebuilt one.
