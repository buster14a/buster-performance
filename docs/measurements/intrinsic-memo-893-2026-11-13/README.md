# The intrinsic set-up's memo of each name's answer, Buster #893 (2026-11-13)

- **Compiler issue:** [buster#893](https://github.com/buster14a/buster/issues/893). This change follows #914's
  negative filter (merged as `c897105a`).
- **Workloads:** all from the frozen corpus (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`) and c-testsuite:
  - `-c` of `sqlite3.c` (SHA-256 `0a409f16…`) with the 9700X job's options;
  - musl's 1,336 units as one command on one lane, with the corpus README's options (the first source of each base
    name, as `whole-build-672-2026-11-12` selects them; `scripts/prepare.sh`);
  - c-testsuite (`5c7275656d751de0e68b2d340a95b5681858ed07`), its 220 `single-exec` units as one command on one lane,
    and as one process each.

## Sources

| label | revision | what |
| --- | --- | --- |
| base | `26f0bb0e1ab0ae8fc0a7c119064796dfd4b0d5fa` | main |
| first | `040e49e7ff0664de84c9f796cc77a2cd16646987` | the memo, every operand taken in the pass's loop |
| gather | `ed3d6221b2f44aa9671b3280e4d6c092f176967b` | 16-lane gathers find the operands that aren't a miss's; the rest out of line |
| scalar mask | `db8eb2a0e9d9941884fe54b244ef8243ab98432e` | A/B only, not pushed: the same mask by a scalar loop (`variants/scalar-mask-db8eb2a0-from-ed3d6221.diff`) |
| final | `2c52baea9756d54402ab9112c9b495d89f5e19cd` | the gather version with the memo's reservation sized by the table's ids, 8 KB doubling |

`variants/gather-a7a343e1-from-040e49e7.diff` is an earlier gather candidate, built but not timed. Each tree is a
`git archive` of its commit (`COMMIT` beside it), built on the host by `scripts/build-tree.sh`
(`BUSTER_DEBUG_INFO=0 ./build.sh`, Release, `-march=native`, which is znver5), each build its own hold of the lock.

| build | executable SHA-256 |
| --- | --- |
| base | `2ef8f43a3a0e944df52fcac959f1c1be1b731944bd5277ccbd9bfc3d22fffbc4` |
| first | `aaa419a72f8e16bd3d69ad9013043350d29d8d6bcfaa75a832889e7ede22f028` |
| gather | `abcd0bb37f6e828b3d885aaef91bd301427f4f1e0577a73fa0ece09c4ca0d36f` |
| scalar mask | `4b27692a9c772387da46c51fd25fb8e3a6ee3b9b4598ec07f8b25054f55e85b9` |
| final | `eaa8e39dd74c28c28966fb884983530ca635ee64a2b3fd5b9e040e826d242c82` |

## Host and method

The Ryzen 7 9700X (`benchpress`): Linux 6.18.50, clang 23.1.1, perf 7.2.9, transparent huge pages `always`, CPU 2,
whose governor is `performance` and whose SMT sibling is offline.

- **Holds.** Every build and measured step held the machine's lock on its own (`exclusive.sh`, owner `claude-893`),
  started by `scripts/queue.sh`, a step a line. Several short steps share a hold where the lock was busy (`q4.txt`,
  `q8.txt`, `q10.txt`), up to about 2.5 minutes. `raw/holds.txt` has each step's start and status; the queue logs' other
  lines (other holders' waits) are left out. Each result file starts with the lock's owner line of its own hold.
- **Objects** (`scripts/objects.sh`): base, head and head `--scalar` on the three workloads, from the same directory
  name. `-g -Wall -Wextra` for sqlite3.c and c-testsuite, `-Wall` for musl. Then a `diff -r` of the objects and a `cmp`
  of standard error.
- **Whole processes** (`scripts/timing.sh`): `time-runs` with `--build` per build, which runs each executable from
  fresh copies (`--copies N`, and 1 copy when not given), in a Williams design's order, on CPU 2.
- **Single-file processes** (`scripts/small.sh`): `time-runs` with three copies each over three c-testsuite units.
  `scripts/rusage.sh` and `rusage.py` give the 220 units' processes' `wait4` rusage, from fresh copies.
- **Profiles:**
  - `scripts/annotate.sh`: 20 compiles of sqlite3.c under `perf record -e cycles:u -c 200003`, then the set-up's
    annotation.
  - `scripts/muslprof.sh`: 3 runs of musl's command, the same way.
  - `scripts/profile.sh` (round 1): period 20,011, which perf throttled to about a quarter of the samples. Its shares
    are kept, but the later scripts' are the ones to use.
- **Faults** (`scripts/faults.sh`, `copies.sh`, `faultaddr.sh`): minor faults per process of small units, from the
  trees' executables and from fresh copies, and every page fault's data address and faulting symbol
  (`perf record -e page-faults -d`) for one `-c` of an empty unit.

### Which file is which revision

| files | head | other |
| --- | --- | --- |
| `timing/*-1511*`, `*-1515*`, `*-1519*`, `files/`, `profile/` | first | |
| `timing/*-head-db8eb2a0-*`, `rusage/rusage-head-db8eb2a0-*`, `annotate/head-db8eb2a0-*` | gather | scalar mask |
| `timing/*-copies*-1701*`, `-1702*`, `rusage/rusage-170110.txt`, `faults/`, `faultaddr/` | gather | |
| `timing/*-copies*-1709*`, `-1711*`, `-1712*`, `small-*`, `rusage/rusage-170926.txt`, `annotate/head-*`, `muslprof/head-*` | final | |
| `annotate/base-*`, `muslprof/base-*` | base | |

`objects/compare.txt` has every round's comparisons, appended in order. They are the first's, the gather's and the
final's.

## Results

### Objects

Every object (sqlite3.c, musl's 1,336 units, c-testsuite's 220: `objects/objects.sha256`) and every diagnostic line
(2,865) is the same bytes for base, head and head `--scalar`, for the first, the gather and the final revisions.

### Whole processes, final against base (fresh copies)

| workload | wall time, base → final | user cycles | instructions |
| --- | ---: | ---: | ---: |
| musl, 1,336 units, one command (2 copies × 6 runs) | 816.9 → 797.5 ms, **−2.37%** (−2.58% to −2.29% over copies) | 3,526.2 → 3,427.8 M, −2.79% | 9,064.6 → 8,976.6 M, −0.97% |
| c-testsuite, 220 units, one command (3 × 15) | 66.17 → 64.70 ms, **−2.22%** (−2.94% to −1.79%) | 240.6 → 233.0 M, −3.16% | 566.6 → 562.5 M, −0.73% |
| `-c sqlite3.c` (3 × 15) | 124.11 → 124.11 ms, −0.00% (−0.22% to +0.22%) | 600.9 → 601.5 M, +0.10% (−0.36% to +0.37%) | 1,351.5 → 1,346.0 M, −0.40% |
| c-testsuite `00050.c`, one process (3 × 21) | 0.852 → 0.832 ms, −2.38% (−3.54% to −0.32%) | −0.66% (−5.46% to +2.98%) | |
| `00100.c` | 0.751 → 0.759 ms, +1.07% (−5.02% to +2.08%) | −0.31% (−6.30% to +3.77%) | |
| `00170.c` | 1.792 → 1.791 ms, −0.06% (−2.49% to +1.40%) | −0.50% (−1.04% to +0.45%) | |

The 220 units as processes (`rusage/rusage-170926.txt`, 10 rounds, fresh copies): user and system time per process
0.7291 + 0.1274 → 0.7462 + 0.1121 ms (0.8565 → 0.8583, +0.2%), minor faults 533.8 → 537.7. At about a millisecond a
process, rusage's split between user and system time is coarse.

### The set-up's profile

`-c sqlite3.c`, 20 compiles, samples at 200,003 cycles (10 K cycles of a compile each):

| symbol | base | gather | scalar mask | final |
| --- | ---: | ---: | ---: | ---: |
| `check_input_intrinsic_initialize` | 370 | 183 | 127 | 189 |
| `check_input_intrinsic_resolve` | inlined | 77 | 79 | 82 |
| `check_input_intrinsic_take` | — | 65 | 77 | 60 |
| `builtin_intrinsic_filter_candidates` | 29 | 67 | 51 | 53 |
| set-up, all | 399 | 392 | 334 | 384 |
| `__memcmp_evex_movbe` (all callers) | 102 | 105 | 112 | 100 |

musl's command, 3 runs (`muslprof/`): the set-up's functions 883 → 308 samples (−65%), `memcmp` 702 → 575, of
53,742 and 52,374 in all. Round 1's throttled profile of the first revision (`profile/`) gives the same picture for
musl: 1.67% → 0.46% of cycles.

### Steps that changed the design

- **The first revision spilled.** It took every operand in the pass's own loop, and its annotation showed why that
  was slow. clang kept the loop's mask and the batch's counts in stack memory around the inlined batch search: a store
  and a reload of the mask for each operand. On sqlite3.c the function took 741 throttled samples against base's 584,
  for 3.7 M fewer instructions; musl was still −2.68% (`timing/*-1515*`).
- **Gathers against a scalar mask** (`timing/*-head-db8eb2a0-*`, one copy):

  | workload | gather | scalar mask |
  | --- | ---: | ---: |
  | musl | −2.10% | −1.33% |
  | c-testsuite command | −1.94% | −0.87% |
  | sqlite3.c | +0.44% | +0.03% |

  On sqlite3.c, a unit the table hasn't seen, nearly every block has operands to take, and the scalar mask's own
  samples are fewer (127 against 183). Where the memo is warm, which is what it is for, the gathers win.
- **The faults of the trees' executables were their files'.** Run from the build trees, the gather build took 26 more
  faults a process than base, even on an empty unit (`faults/faults-165537.txt`). They were `.rodata` pages: 4 faults
  for base, 25 for head (`faultaddr/`), on constants both read. From fresh copies, written alike, the difference is 2 or
  3 faults (`faults/copies-165949.txt`): base's tree executable faults 19 fewer times than its own copy does. The tree
  executables' page-cache state differed; the code did not. `time-runs` always ran copies.
- **The memo's first reservation.** The gather revision reserved the table's whole id room (40,960 ids, 82 KB): past
  the arena's 64 KB of base pages, so each process took the huge-page advice and a split mapping. Per process that was
  +0.6% (0.8541 → 0.8592 ms, `rusage/rusage-170110.txt`). The final revision starts at 8 KB and doubles: +0.2%.

## Limits

- One build of each revision, at one code placement. `time-runs`' copies measure the file's pages, not the code's
  address (`./build.sh shifts`). sqlite3.c's ±0.3% and the small files' ±1% are within what placement alone moves.
- The set-up still costs a unit whose names the table hasn't seen what main's does (399 against 384 samples on
  sqlite3.c). That cost is the lookups of its 10.8 K new names: the filter's key loads from the spellings and the false
  positives' searches. The memo doesn't change it; a follow-up issue on buster has it.
- The scripts' `HEAD_TREE` named the head tree of each round; `q*.txt` are the rounds' steps as run, and the commands
  in `holds.txt` name each step's scripts and arguments.
