# The intrinsic set-up's fill and exact table, Buster #2654 and #893 (2026-11-13)

- **Compiler issues:** [buster#2654](https://github.com/buster14a/buster/issues/2654), the cost
  [buster#2653](https://github.com/buster14a/buster/pull/2653)'s memo left in a unit whose names its table had never
  seen, toward [buster#893](https://github.com/buster14a/buster/issues/893)'s criterion that the set-up's cycles on
  `sqlite3.c` fall. The compiler PR is [buster#2686](https://github.com/buster14a/buster/pull/2686).
- **Workloads**, as in `intrinsic-memo-893-2026-11-13` (this repository), the frozen corpus and c-testsuite
  `5c7275656d751de0e68b2d340a95b5681858ed07`:
  - `-c sqlite3.c` (SHA-256 `0a409f16…`) with the 9700X job's options;
  - musl's 1,336 units as one command on one lane;
  - c-testsuite's 220 units as one command, and as one process each.

## Sources

| label | revision | what |
| --- | --- | --- |
| base | `447192ef56f05842b5d6dae673d0cf6089b02983` | main, with #2653's memo and #2635's skips |
| fill, gathers | `90758cc0d4a6cb034c2d669a7f5394aa23d91605` | the id-order fill, the exact table, #2653's gathers of the operands' codes |
| fill, gathers (b) | `18145a06609eafc4eefbd26990c7a1b2db5f16b3` | the same code, without the catalogue's `baked.h` include; the same executable bytes |
| scalar loop | `8ed0b89281c5a8562bfcb8ba2f0b3046517c2823` | A/B only, not pushed: the operands' codes by a scalar loop (`variants/scalar-8ed0b892-from-18145a06.diff`) |
| final | `3a1001e091b6b9180c2b6bdc1e588f19fa3a681a` | the scalar loop adopted, the memo's gather padding dropped |

`raw/holds-and-builds.txt` has each tree's commit and its executable's SHA-256, and each step's start and status. Each
tree is a `git archive` of its commit, built on the host by `scripts/build-tree.sh` (`BUSTER_DEBUG_INFO=0 ./build.sh`,
Release, `-march=native`: znver5), each build its own hold of the lock.

## Host and method

The 9700X (`benchpress`), CPU 2: Linux 6.18.50, clang 23.1.1, perf 7.2.9, transparent huge pages `always`. The
scripts are those of `intrinsic-memo-893-2026-11-13`, with `BASE_TREE` naming the base and `muslprof.sh` taking a third
tree.

- **Holds.** Each line of `scripts/q12.txt`, `q13.txt` and `q14.txt` is one hold of the lock (owner `claude-893`), up to
  about four minutes. Only my scripts' own lines are kept; the queue logs' other holders' waits are left out.
- **Objects** (`objects.sh`): every object and diagnostic of the three workloads by base, head and head `--scalar`.
- **Whole processes** (`timing.sh`, `small.sh`): `time-runs`, each build from fresh copies, in a Williams design's
  order. `rusage.sh` measures the 220 single-file processes from fresh copies.
- **Profiles:**
  - `annotate.sh`: 20 compiles of `sqlite3.c`;
  - `muslprof.sh`: 3 runs of musl's command.

  Both use `perf record -e cycles:u -c 200003`; on `sqlite3.c` a sample is 10 K cycles of a compile.

## Results

### Objects

Every object and diagnostic of the three workloads is the same bytes for base, head and head `--scalar`, for the fill
(`round-12/objects`) and the final head (`round-14/objects`).

### Final against base (`round-14`)

| workload | wall time | user cycles | instructions |
| --- | ---: | ---: | ---: |
| `-c sqlite3.c` (3 copies × 15) | 124.00 → 123.48 ms, **−0.42%** (−0.52% to −0.21% over copies) | −0.24% (−0.42% to +0.07%) | 1,355.5 → 1,354.1 M, −0.11% |
| musl, one command (2 × 6) | 726.66 → 723.98 ms, **−0.37%** (−0.46% to −0.21%) | −0.38% (−0.48% to −0.35%) | 7,785.8 → 7,785.0 M, −0.01% |
| c-testsuite, one command (3 × 15) | 58.38 → 58.31 ms, −0.11% (−0.41% to +0.30%) | −0.01% | 450.0 → 449.6 M, −0.09% |
| c-testsuite `00050.c`, one process (3 × 21) | 0.829 → 0.822 ms, −0.89% | −0.92% (−3.45% to +2.23%) | |
| `00100.c` | 0.745 → 0.740 ms, −0.61% | +1.40% (−0.80% to +5.55%) | |
| `00170.c` | 1.734 → 1.730 ms, −0.21% | +0.30% (−0.41% to +1.05%) | |

The 220 units as processes (`round-14/rusage`): user and system time 0.7077 + 0.1205 → 0.6985 + 0.1285 ms a process
(0.8282 → 0.8270), minor faults 536.0 → 531.0.

### The set-up's profile

| symbol, samples | base | fill, gathers | scalar loop | final |
| --- | ---: | ---: | ---: | ---: |
| **`sqlite3.c`, 20 compiles** | (round 14) | (round 13) | (round 13) | (round 14) |
| `check_input_intrinsic_initialize` | 188 | 186 | 143 | 148 |
| `check_input_intrinsic_resolve` | 67 | — | — | — |
| `check_input_intrinsic_take` | 76 | 5 | 10 | 4 |
| `builtin_intrinsic_filter_candidates` | 53 | — | — | — |
| `check_input_intrinsic_fill` | — | 61 | 63 | 55 |
| set-up, all | **384** | 252 | 216 | **207** (−46%) |
| `__memcmp_evex_movbe`, all callers | 97 | 103 | 85 | 79 |
| **musl, 3 runs** | | | | |
| set-up, all | **148** | 159 | 105 | **115** (−22%) |
| `__memcmp_evex_movbe`, all callers | 236 | 229 | 247 | 246 |

Round 13's base was 372 samples on `sqlite3.c` and 151 on musl.

## Steps that changed the design

- **Round 12, the fill with gathers** (`round-12`): the set-up fell from 378 to 253 samples on `sqlite3.c`. musl's set-up
  stayed where it was (156 against 158), and its command read +0.30% wall. The annotation (`round-12/annotate`) put the
  pass's samples on the first load of each block's token columns and on waiting for the gathers.
- **Round 13, gathers against a scalar loop** (`round-13`): operands are about a fifth of the tokens, so the 16-lane
  gathers of the operands' codes ran mostly empty.

  | set-up samples | base | gathers | scalar loop |
  | --- | ---: | ---: | ---: |
  | `sqlite3.c` | 372 | 252 | 216 |
  | musl | 151 | 159 | 105 |

  The final head takes the scalar loop. The fill's own 16-lane filter, which every id passes through, stays vector.

## Limits

- One build of each revision, at one code placement. `time-runs`' copies measure the file's pages, not the code's
  address. The single-file processes' differences are within their copies' spread.
- `memcmp`'s samples have every caller's, most of them outside the set-up. Between two builds of the same set-up code
  they vary by about 20.
