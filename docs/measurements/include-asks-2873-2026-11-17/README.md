# The include search asks a directory for a subdirectory it keeps failing for (buster#2873), 2026-11-17

The record of the first of the files' rows of
[buster#2873](https://github.com/buster14a/buster/issues/2873) (the kernel row of a unit compiled by a process of
its own): [buster14a/buster#2941](https://github.com/buster14a/buster/pull/2941), two commits on main `1b4acb2c8`.
What it could not explain about two builds is [buster#2942](https://github.com/buster14a/buster/issues/2942). The
design is in buster's `docs/c-files.md`, "A search directory asked for a subdirectory".

A failed probe (ENOENT) of a path with a first component after its search directory is counted for that component, in
one of 16 slots of the directory's record. At the component's third miss the cache `stat`s the component's own path,
once. A directory without it then answers ENOENT for every path under it, without a system call.

Everything timed is from the 9700X (`benchpress`), CPU 2, under the lock a run, Release builds as CI's
(`scripts/build-tree.sh`), each compiler a fresh copy, the counts those of the CPU as a whole (`scripts/ab.sh`: the
exit's teardown and the exit helper included), rounds in ABBA order. A cell of an A/B table is the median paired
difference of B from A in percent of A, its quartiles, and the rounds in which B read less.
`results/9700x/tables.md` has every A/B of the record (`scripts/tables.py`).

## 1. The calls

`strace` of `-c` (`scripts/counts.sh`, `results/9700x/counts-head`): main's build (`base2`: main `2d8174328`, whose
compiler sources main `05c5d95d7` and `1b4acb2c8`, the pull request's base, have unchanged) and the pull request's
head (`head`: `patches/files-head.patch` on `05c5d95d7`, which is the sources and the list of the pull request's two
commits, `patches/0001-*` and `0002-*`; `docs/c-files.md` took this job's figures afterwards).

| `-c` of | opens | of them failed | `stat` of a path | objects |
| --- | ---: | ---: | ---: | --- |
| a unit with only `<stdio.h>` (`scripts/hello.c`) | 87 to 59 | 52 to 24 | 8 to 10 | the same bytes |
| `sqlite3.c` | 380 to 274 | 207 to 101 | 9 to 20 | the same bytes |
| a musl unit (`string/strlen.c`) | 37 to 37 | 23 to 23 | 9 to 9 | the same bytes |
| musl's 1,336 units, in the cloud container (`results/cloud/musl-census.txt`) | 70,664 to 70,578 | 49,834 to 49,748 | 13,774 to 14,624 | |

musl's units make 850 asks, 259 of them of a component its directory lacks, which spare 86 opens.

## 2. The asks' own effect: one executable, its asks off and on

`scripts/job-knob.sh`: the pull request's code with its threshold read from the environment
(`patches/files-knob.patch`, `BUSTER_ASKS`; 0 is never), so that one copy of one executable runs both sides: the
same layout, the same state of the page cache, environments of one size (`ab.sh`'s `SAME`, `A_ENV`, `B_ENV`). A is
the asks off.

| B | `hello.c`, 41 rounds: kernel cycles | user instructions | musl's units, 11 rounds: kernel cycles | user cycles |
| --- | ---: | ---: | ---: | ---: |
| asks at the third miss | -0.85% [-1.70, -0.35] 35/41 | -0.05% 41/41 | +0.01% [-0.10, +0.15] 5/11 | -0.05% [-0.06, -0.04] 9/11 |
| the same again | -1.07% [-1.72, -0.23] 33/41 | -0.05% 41/41 | +0.04% [-0.08, +0.25] 5/11 | -0.04% [-0.08, +0.02] 7/11 |
| at the fourth | -0.85% [-1.82, -0.01] 31/41 | -0.05% 41/41 | +0.28% [-0.09, +0.43] 4/11 | +0.05% [-0.00, +0.05] 3/11 |
| at the fifth | -0.99% [-1.87, +0.01] 30/41 | -0.05% 41/41 | -0.15% [-0.23, +0.08] 7/11 and +0.14% [+0.01, +0.29] 2/11 | +0.03% and -0.01% |
| off again (the control) | -0.05% [-0.70, +0.68] 22/41 | +0.00% 20/41 | +0.06% [-0.16, +0.18] 4/11 and -0.17% [-0.29, +0.30] 6/11 | +0.03% and -0.05% |

- The unit with `<stdio.h>` runs 0.85% to 1.07% fewer kernel cycles with its asks: 31,000 to 39,000 of a compile's
  3.6 M, for 28 opens spared and 2 `stat`s made.
- musl's units read the same with their asks on and off, at every threshold.
- The thresholds read alike, so the asks stay at the third miss, the earliest that isn't lost on musl's components
  (section 4).
- With its asks on, `hello.c` takes one more page fault a compile (+0.18% in both comparisons, 39 and 38 rounds
  of 41). Which page was not found: `scripts/faults-knob.sh` recorded each fault's address, but the addresses move
  from run to run (`results/9700x/faults-knob/summary.txt`).

## 3. Main against the pull request's head

`scripts/job-head.sh`, `results/9700x/abh-*`: `base2` against `head`, and `base2` against a second copy of itself
(`same`) in the same job.

| A/B | rounds | kernel cycles | user cycles | user instructions | page faults | instruction TLB misses |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `hello.c`, head | 41 | -1.11% [-1.79, -0.14] 31/41 | -0.89% [-1.33, +0.80] 23/41 | +0.00% | -0.57% 37/41 | +0.27% |
| `hello.c`, head again | 41 | -0.89% [-2.55, +0.28] 26/41 | -0.11% [-1.23, +0.80] 21/41 | +0.00% | -0.56% 41/41 | +0.12% |
| `hello.c`, same | 41 | +0.11% [-0.72, +0.49] 20/41 | -0.14% [-0.37, +0.65] 21/41 | -0.00% | +0.00% | -0.01% |
| musl's units, head | 11 | +0.10% [-0.15, +0.18] 5/11 | +0.17% [+0.11, +0.23] 1/11 | +0.03% | -0.23% 11/11 | -0.96% 11/11 |
| musl's units, head again | 11 | +0.14% [+0.10, +0.33] 1/11 | +0.07% [+0.00, +0.16] 3/11 | +0.03% | -0.22% 10/11 | -1.03% 11/11 |
| musl's units, same | 11 | -0.15% [-0.21, +0.10] 8/11 | -0.07% [-0.09, -0.02] 8/11 | -0.00% | +0.00% | -0.05% |
| `sqlite3.c`, head | 21 | -0.26% [-1.84, +1.99] 11/21 | +0.02% [-0.24, +0.38] 10/21 | -0.0004% 21/21 | -0.05% | +1.28% |
| `sqlite3.c`, same | 21 | +0.09% [-3.72, +1.40] 10/21 | -0.13% [-0.33, +0.01] 13/21 | -0.00% | +0.00% | -0.43% |

- `hello.c`: the kernel cycles section 2 gives the asks, and 0.57% fewer page faults, which are the build's and
  not the asks' (section 2: one more a compile).
- musl's units: 0.03% more instructions, the counting's (section 5), which reads as 0.07% to 0.17% of their user
  cycles; their kernel cycles within 0.15% of main's, as main's copies are of one another.
- `sqlite3.c`: within what two copies of main read.

`results/9700x/abx-*` (`scripts/job-fin.sh`) is the same comparison for `fin`, a build of the same code before its
test's last change (`patches/files-fin.patch`: the code files are byte for byte the head's), with the units as one
command, `tiny.c`, and an empty file's `-fsyntax-only` and `-E -P` beside it.

### What two builds read against one another on musl's units

| A/B (musl's units, 11 rounds) | kernel cycles | user cycles |
| --- | ---: | ---: |
| `base2` against `head` | +0.10%, +0.14% | +0.17%, +0.07% |
| `base2` against `fin` | +0.73% [+0.67, +0.78] 0/11, +0.45% [+0.26, +0.73] 1/11 | +0.21%, -0.10% |
| `base2` against `finoff` (`fin` with its asks never made) | +0.28% [+0.04, +0.43] 3/11 | +0.13% |
| `base2` against the knob build, asks at the third miss (`job-knob2.sh`) | +0.21%, +0.31% | +0.26%, +0.38% |
| `base2` against the knob build, asks off | +0.45%, +0.69% | +0.77%, +0.44% |
| `fin` against the knob build, both asking | +0.11%, -0.10% | +0.24%, +0.08% |
| the knob build, asks off against on, one copy (section 2) | +0.01%, +0.04% | -0.05%, -0.04% |
| main's build against a copy of itself, the record's ten runs | -0.15% to +0.37% | -0.39% to +0.16% |

Builds of the same asks read up to 0.6% of kernel cycles apart on these units, and the knob build read further
above main with its asks off than with them on, in separate runs, though one copy of it reads the two as equal. So
a difference between two builds here, under about 0.8%, says nothing of the asks. What it is was not found:

- `fin` and `finoff` place every function of the start's code and of the checker's at the same addresses; their
  cold `.text` is 32 bytes apart from `files_test_listed_walk` on, a test's function. Yet a musl unit reads 2% to 8%
  more misses of the first-level instruction cache by `fin` than by `finoff` or `base2`
  (`results/9700x/unit-cost-fin/tables.md`), with the same instructions.
- The asks are not it: the knob build's settings read the same misses (`results/9700x/unit-cost-knob/tables.md`).
- The code that moved is not run: `aio.c`'s compile spends 55% of its user cycles in the start's code, 31% in
  the checker's section and 7% in `.text` (`strlen.c`'s: 46%, 34%, 10%), and every function of `.text` its samples
  name is one the list places first in it, before the point where the two builds part
  (`results/9700x/where-fin`, `scripts/where.sh`).

## 4. Why the third miss, and a `stat`

- The costs (`results/9700x/probecost-1.txt`, `scripts/probecost.c`; warm dentry cache): a failed open of a whole
  path under a subdirectory its directory lacks, 1,265 cycles; a failed `stat` of the subdirectory, 990; a `stat` of
  one that is there, 1,100; an open and a close of it, 2,365.
- The traces of compiles without asks, replayed with an ask at each threshold (`scripts/simulate.py`,
  `results/cloud/simulate-9700x.txt`, `simulate-musl.txt`), in cycles a unit by those costs:

  | asked at the component's | `<stdio.h>` alone | `sqlite3.c` | a musl unit, of 1,336 |
  | --- | ---: | ---: | ---: |
  | first miss | +37,070 | +181,940 | -5,197 |
  | second | +33,990 | +170,005 | -2,864 |
  | third | +33,440 | +162,855 | -597 |
  | fourth | +30,910 | +154,990 | -162 |
  | fifth | +28,380 | +146,135 | -37 |

  musl's units, with seven `-I` directories, have 2,826 absent components that fail twice or more, only 259 of them
  a third time, and 1,332 that are there and fail twice or more.
- Measured (section 2), the unit with `<stdio.h>` keeps 31,000 to 39,000 kernel cycles, as predicted, and musl's
  units read no loss at the third miss.

## 5. The counting: one compare a miss

Every failed probe is counted, in units that never ask too. A component's key is 16 bytes, its name and zeros, by
one masked load of the bytes after the directory's; the slot is one compare of the key with all 16 slots, four a
vector. `results/9700x/unit-cost-fin` (`scripts/unit-cost-fin.sh`): a musl unit's own counters, 400 runs a compiler,
twice, by `base2`, `scratch` (the same asks with the counting as two loops, over the name's bytes and over the
slots: `patches/files-scratch.patch`), `finoff` and `fin`. More than `base2`, a unit:

| unit | instructions: loops | no loop | branches: loops | no loop | mispredicted: loops | no loop |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `aio/aio.c` | +16,750 | +9,383 | +3,939 | +1,507 | +233 | +304 |
| `aio/aio_suspend.c` | +10,831 | +5,702 | +2,594 | +896 | +320 | +234 |
| `complex/__cexp.c` | +5,618 | +2,830 | +1,359 | +434 | +259 | +202 |
| `conf/sysconf.c` | +15,140 | +8,744 | +3,654 | +1,336 | +420 | +354 |
| `ipc/msgctl.c` | +8,879 | +5,716 | +2,082 | +876 | +364 | +152 |

Without a loop the counting is half the instructions and a third of the branches. Its mispredicted branches are 57
to 212 fewer in four units, and 71 more in one.

## 6. The start order

`file_cache_count_miss`, inlined on main, is a function of its own with the asks (850 bytes). Left out of
`cmake/BusterStartOrder.txt` it sat in the cold part of `.text`, a page of code more for every process:
`results/9700x/abstat3-musl-ask3.txt` and `abstat3-musl-ask3-again.txt` (an earlier version of the asks, main's
list) read 1.88% and 1.85% more instruction TLB misses on musl's units, 5 rounds of 5.

- The list was made again from the code's own build (`scripts/order.sh`, `results/9700x/order1f`;
  `patches/order-fin.patch`): 1,441 functions where main's has 1,440, that one more. Seven of the C library's
  names, which read the processors online, move up among the small commands' functions.
- Made once more from the build linked with it (`order2f`), the list has the same functions, two lines in another
  place (`results/9700x/order-compare-fin.txt`).
- With it, musl's units read 0.96% and 1.03% fewer instruction TLB misses than main's (section 3).
- Main's own list was fresh: made again from main `d1cf1fe82` it gained one function (`results/9700x/order-base`).

## 7. The versions before this one

Each was built and measured on the 9700X; `results/9700x/tables.md` has their A/Bs, `patches/` their code.

| version | what it did | what the measurement said |
| --- | --- | --- |
| `ask` (`job-ask.sh`) | asked at the second miss, by an open of the subdirectory | musl's units, whose components fail twice and are often there, paid an open and a close each: +0.10% instructions |
| `ask3` (`job-ask3.sh`) | the third miss, a `stat` | musl +0.06% instructions; +1.9% instruction TLB misses: the function outside the start order |
| `final` (`job-final.sh`) | the start order made again; components in lists the arena holds | TLB misses below main's; a 4 KB frame for the asked path |
| `slots` (`job-slots.sh`) | 16 slots in the directory's record, the asked path in the arena | `hello.c` -0.99%, -1.28% kernel cycles |
| `scratch` (`job-variants.sh`, `job-last.sh`, `job-command.sh`) | the same, tidied; with `off` (asks never made), `none` (nothing of it run) and `orderonly` (main's code, the new list) | the list alone, on main's code, costs main 2.3% more TLB misses |
| `vec` (`job-vec.sh`) | the counting without a loop; a key's last byte its length | half the instructions of the loops |
| `fin` (`job-fin.sh`) | a key is the name's bytes | the pull request's code |

## 8. The tests

- `test-preprocessor`: `pp_test_directory_asks` (28 groups of searches, each group's opens, asks and answers pinned
  in a table; every search's result, path, file and error the same as with the asks off; a shared cache; listings)
  and `pp_test_component_keys` (21 paths, each ending where an unreadable page begins, and again with bytes after
  it). `test-files`: the walk with one ask, on every lane count.
- The fault campaign (`scripts/mutants.py`, in a copy of the tree): 44 faults of the new code, one at a time, a
  Debug build each, then `test-preprocessor`'s parts 1 and 4 of 4 and `test-files`
  (`results/cloud/campaign/results-frozen.txt`): **43 fail a test.** The one that passes makes a component absent on
  any error of its ask, not on ENOENT alone. On a file system that holds still the two are the same: a component is
  asked for only after three probes under it failed with ENOENT, and its own `stat` then succeeds or fails with
  ENOENT. The same faults against the test before its table of counts: 25 of the 25 run (`results-vec.txt`). The
  earlier versions' campaigns: `results-lists.txt`, `results-slots.txt`.
- A file system whose directories aren't listed (NFS, FUSE: none here): with `file_cache_exact_names` made to refuse
  every file system (`mutants.py run unlisted-file-system`, `results/cloud/tests/unlisted-file-system/`), the
  directory asks and the walk's asks pass by their expectations for such a one. `test-files`'s listings test, which
  is main's, fails there, and fails the same way on main with that change (`main-test-files.out`).
- The cloud container's native Release build of the final tree (`scripts/final-checks.sh`,
  `results/cloud/tests/`):
  - the 18 headings of the inventory that the includes reach (`scripts/includes.tests`): 15 pass, and 3 fail as
    they do with main's compiler here: the preprocessor against clang on the repository's units and on its cases'
    part 2 of 4, where this container's clang names its resource directory otherwise, and the frozen corpus's
    subset, whose manifests are not here (`earlier/part2-final.txt` and `earlier/part2-main.txt` are part 2's
    failure lines by an earlier version of this code and by main's compiler: the same lines);
  - the 2 headings that take the compiler's own source (`scripts/heavy.tests`) pass;
  - the workflow's parse of `main.c` with the complete driver exits 0;
  - clang's `-fsyntax-only` of `main.c` with the fuzzing build's flags, and with znver5's and the baseline's and
    the complete driver, prints nothing.
- The sanitizer rows a pull request's checks don't run (`scripts/sanitizers-files-native.sh`: native memory,
  address and thread; a Release build each, `test-preprocessor`'s four parts, `test-files`, and `-c` of `hello.c` and
  of `sqlite3.c` under memory and address): the three builds and their 19 commands, each with status 0, and no
  sanitizer wrote a report
  (`results/cloud/sanitizers/progress.txt`).
- The baseline host (`BUSTER_HOST_ARCH=x86-64`: no AVX-512, the intrinsics emulated), a Debug build
  (`scripts/base-check.sh`, `results/cloud/tests/baseline-host/`): `test-preprocessor`'s parts 1 and 4 of 4 and
  `test-files` pass.

## 9. The other files' rows: the source's mapping and the object's write

[The specification](https://github.com/buster14a/buster/issues/2873#issuecomment-6944941052) left the files' other
rows one measurement each. Both are one copy of one executable, the pull request's head, on both sides.

**How a file past the read limit (16 KB) gets its bytes** (`scripts/job-bytes.sh`, `patches/files-bytes.patch`: from
the environment; A is the code as it is, mapped with `MAP_POPULATE` on one lane):

| B | `sqlite3.c`, 21 rounds: kernel cycles | page faults | `hello.c`, 41 rounds: kernel cycles | page faults | musl's units, 11 rounds: kernel cycles |
| --- | ---: | ---: | ---: | ---: | ---: |
| mapped without `MAP_POPULATE`, its pages faulted in as the lexer reads them | +0.84% [-1.19, +1.89] 9/21 and -1.01% [-1.78, +2.14] 11/21 | +2.70% | -0.06% and -0.03% | +0.57% | +0.26% [-0.22, +0.35] 4/11 |
| every file read into the lane's arena | +6.06% [+4.46, +7.53] 0/21 | +7.24% | +0.84% [+0.22, +1.52] 7/41 | +4.21% | |
| populated again (the control) | +1.48% [-1.37, +2.67] 8/21 | +0.00% | -0.15% [-0.57, +0.55] 22/41 | +0.00% | -0.11% [-0.15, +0.10] 8/11 |

- **Faulting the source in reads as populating it does:** 155 more faults on `sqlite3.c`, its 9 MB sixteen pages a
  fault, and kernel cycles inside what the setting reads against itself. The census's small program had it cheaper a
  page (179 cycles against 256); over the source's 2,300 pages that is 0.18 M cycles, 0.2% of the compile's kernel
  cycles, which these runs don't resolve. Nothing to change.
- **Reading instead of mapping is worse:** 5.3 M kernel cycles more on `sqlite3.c`, in every round.
- The objects are the same bytes in every round.

**The object's write** (`scripts/job-object.sh`: `-c sqlite3.c` with its object written in `/dev/shm`, in place over
the round before's, against the same compile with the object's path a link to `/dev/null`; 81 rounds, twice):

| | kernel cycles | user cycles |
| --- | ---: | ---: |
| to `/dev/null`, less than to the file | -0.50 M [-1.34, +0.48], -0.60%, 53/81 | -0.04% |
| again | -0.40 M [-1.57, +0.77], -0.48%, 48/81 | +0.03% |

The write is 0.4 M to 0.5 M of the compile's 82.5 M kernel cycles, 0.6 to 0.7 cycles a token: one copy of the object's
bytes into pages the file already has (`object_writer.c` writes in place and never truncates). There is no change
here with evidence behind it.

## 10. Files

- `patches/`: `files-head.patch` (the pull request's tree against main `05c5d95d7`), `0001-*`, `0002-*` (its two
  commits), and each measured version's code against main `2d8174328` or `d1cf1fe82` (`files-*.patch`,
  `order*.patch`).
- `scripts/`: the harness (`ab.sh`, `build-tree.sh`, `lock.sh`, `counts.sh`, `order.sh`, `unit-cost*.sh`,
  `where.sh`, `faults-knob.sh`, `probecost.c`, `statcost.c`), each job (`job-*.sh`), the census and its replay
  (`census.sh`, `musl-census-run.sh`, `probes.py`, `simulate.py`), the tables (`tables.py`, `unit-tables.py`), the
  campaign (`mutants.py`) and the cloud container's checks (`run-list.sh`, `parse.sh`, `*.tests`,
  `sanitizers-files-native.sh`, `base-check.sh`).
- `results/9700x/`: every job's counts a round (`ab*-*/NAME-ROUND.csv`), `abstat*-*.txt` (their statistics),
  `tables.md`, the system calls' traces (`counts*`), the lists (`order*`), the units' counters (`unit-cost*`), the
  logs and the lock's holds (`logs/`). `musl-units-stderr.txt` is what every pass of musl's units writes, the same
  bytes by every compiler.
- `results/cloud/`: the census, the replays, the campaign and the tests' logs.
