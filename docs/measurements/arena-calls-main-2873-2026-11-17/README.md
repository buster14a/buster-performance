# The arenas' system calls on today's main: the second piece of buster#2873's kept rows, as its pull request (2026-11-17)

[`arena-calls-2873-2026-11-16`](../arena-calls-2873-2026-11-16/README.md) has the piece itself: what it does, what was
tried first and why it cost more, and its A/B on buster#2885's head. It left the piece as seven patches without a
pull request. This record is what was done to make it one, by the session that took the issue over
([the claim](https://github.com/buster14a/buster/issues/2873#issuecomment-6937495274)): the patches on today's main,
the start order made again there, the A/B and the tests taken again, and the sanitizer rows.

**Result.**

- **The seven patches apply on main `c7caeb56b` as they are** (`git am -3`, no conflict).
- **The start order is made again:** 1,440 functions where the patches' list had 1,435. buster#2889 and buster#2893
  gave every compile five functions of the lowering's.
- **Main against the piece, on the 9700X:** musl a unit a process -4.69% kernel cycles (5 of 5 rounds), `-c sqlite3.c`
  -1.30% (17 of 21), the small commands -2.4% to -4.0% but an empty file's `-E -P` (+0.24%, 4 of 11). The first record
  had -4.50%, -0.63% and -0.6% to -4.8% on buster#2885's head.
- **musl as one command reads +0.49% kernel cycles in every round,** as in the first record (+0.77%), and -0.36% user
  cycles in every round: 4.8 M cycles fewer in all.
- **Objects and diagnostics are the same bytes** in every round; the 24 test commands pass on the piece's build.
- **`hello.c`'s compile makes 49 calls for its arenas where main's makes 103,** as the first record counted: `mmap` 36
  → 5, `mprotect` 51 → 35, `madvise` 10 → 7, `munmap` 6 → 2 (`strace -f -c` in the cloud container, Release builds of
  main's compile path and of the piece; `tables/strace-hello-*.txt`).

## 1. The tree

- `patches/0001` to `0007`: the first record's seven, as `git am -3` applied them on main `c7caeb56b` (their authors'
  trailers kept). `patches/0008`: the start order made again, and the count of its functions in the build guide.
- **The 9700X built** main `c7caeb56b` (`main`) and the same with the eight commits (`p2`: `scripts/job2.sh`'s
  `p2.patch` is their difference from main), each by one `./build.sh --config Release`.

## 2. The start order

`scripts/job1.sh`: the seven patches on main built as the benchmark builds are (`BUSTER_HOST_ARCH=znver5
BUSTER_DEBUG_INFO=0`), then the first record's `order.sh`: `compiler start-trace` of an empty file's `-fsyntax-only`
and `-E -P`, `tiny.c`'s `-c`, `hello.c`'s `-c`, each of musl's 1,336 units' `-c` and `sqlite3.c`'s `-c`, and `compiler
start-order` of the traces (`tables/order-counts.txt`).

| | the patches' list (traced on buster#2885's head) | made again on main `c7caeb56b` |
| --- | ---: | ---: |
| addresses traced | 1,016,447 | 1,016,193 |
| local functions of `main.c`'s units | 1,156 (4,164 KB) | 1,161 (4,167 KB) |
| functions by name | 279 (184 KB) | 279 (184 KB) |

The five more are `check_lower_branch`, `check_lower_branch_condition`, `check_lower_branch_operand`,
`check_lower_branch_operator` and `check_lower_condition_branches`: a condition's `&&` and `||` as branches
(buster#2889, buster#2893), which musl's units and `sqlite3.c` run. A dozen others changed places.

## 3. Main against the piece

`scripts/job2.sh`: the first record's `ab.sh`, unchanged: fresh copies of each executable, warm-up runs, ABBA rounds,
every compile on CPU 2 under `waitall`, counted on CPU 2 as a whole (`perf stat -C 2`), one hold of the lock an A/B.
Medians, and the paired difference's median (`tables/abstat-*.txt`):

| | kernel cycles | paired | user cycles | paired |
| --- | ---: | ---: | ---: | ---: |
| `-c sqlite3.c`, 21 rounds | 84.92 → 83.82 M | -1.11 M (-1.30%), 17 of 21 | 593.2 → 593.7 M | +0.74 M (+0.12%), 6 of 21 lower |
| musl's 1,336 units, a process each, 5 rounds | 5,458.1 → 5,197.7 M | -255.9 M (-4.69%), 5 of 5 | 5,088.5 → 5,071.1 M | -18.4 M (-0.36%), 5 of 5 |
| the same units as one command, 5 rounds | 991.0 → 996.8 M | +4.87 M (+0.49%), 0 of 5 | 2,790.7 → 2,780.1 M | -10.0 M (-0.36%), 5 of 5 |
| an empty file's `-fsyntax-only` ×100, 11 rounds | 204.1 → 197.3 M | -2.42%, 11 of 11 | 58.9 → 58.8 M | +0.06% |
| an empty file's `-E -P` ×100 | 169.4 → 170.0 M | +0.24%, 4 of 11 | 46.3 → 46.5 M | +0.56% |
| `tiny.c`'s `-c` ×100 | 247.1 → 237.1 M | -3.96%, 10 of 11 | 80.4 → 80.2 M | -0.12% |
| `hello.c`'s `-c` ×100 | 369.8 → 358.5 M | -2.78%, 11 of 11 | 357.8 → 356.7 M | -0.33% |

- **Instructions:** `sqlite3.c` 16,000 more of 1,362.2 M; musl a unit a process 0.47 M more of 11,377.7 M (350 a
  unit); the one command 0.2 M fewer.
- **Page faults:** `sqlite3.c` 5,747 → 5,751 (0 of 21 rounds lower); musl a unit a process +483 of 755,332 a pass
  (0.36 a unit); the one command the same; `hello.c` 2.9 fewer a compile, the three smallest 2 to 4 more.
- **Instruction TLB misses:** musl a unit a process -3.8%, `hello.c` -8.5%, `tiny.c` -2.8%; `sqlite3.c` +8 of 228, the
  one command +4.6%, the two commands on an empty file +3%.
- **Objects:** `sqlite3.c`'s the same bytes in 21 rounds of 21; the one command's 1,336 in 5 of 5. **Diagnostics:**
  each round's standard error is the same bytes by both builds (musl's 198,343 bytes of warnings a pass).
- **The page cache** (`tables/pagecache-and-objects.txt`): after the warm-ups both copies have 12,288 KB of their file
  in huge pages; at the end of `sqlite3.c`'s A/B the piece's copy has 18,432 KB and at the end of musl's 14,336 KB,
  main's still 12,288. The piece gains nothing by it that the rounds show: the four of `sqlite3.c`'s 21 in which it
  read more kernel cycles than main are rounds 13, 14, 18 and 20.
- **The peaks** (`tables/peak-*.txt`, 11 rounds each): `-c sqlite3.c` 241,548 KB by main and 241,584 by the piece; an
  empty file's `-c` 13,760 and 13,860.

**Against the claim's gate** (the row's kernel cycles lower on `sqlite3.c` and on musl a unit a process; the compiles'
cycles, user and kernel, no higher on either; objects and diagnostics byte for byte):

- **Kernel cycles: lower on both.**
- **The compiles' cycles:** musl a unit a process lower in both. `sqlite3.c`'s kernel and user cycles together are
  0.37 M fewer of 678 M by the paired medians; its user cycles alone read +0.12%, with 6 of 21 rounds lower, on the
  same instructions. The first record read +0.29% there and -0.3% by the compile's own counters.
- **Objects and diagnostics: the same bytes.**
- **Outside the gate:** the one command's kernel cycles are 0.49% higher in every round, as the first record found
  and could not place by a profile.

## 4. The tests

`tables/tests.txt`: the first record's 24 commands on the piece's build on the 9700X, a hold of the lock a command
(`test-profile`, `test-lanes`, `test-check-lanes`, `test-baked-tables`, `test-call-graph`, `check-call-graph`,
`test-check-units`, `test-checker-deferred`, `test-checker`'s eight parts and `test-checker-driver`'s eight). Each
has status 0.

## 5. The sanitizer rows

A pull request's checks build without a sanitizer; the merge queue's candidate runs the sanitizer rows. So the piece's
head (`94df07e5d`: main `c7caeb56b` and the eight commits) was built six times in the cloud container, as CI's rows
build (`-O3`, `BUSTER_LINKER=lld`): memory, address and thread, on the `x86-64` host and on the native one
(`scripts/sanitizers.sh`, `tables/sanitizers.txt`). Each build ran:

- the tests of what the piece touches: `test-lanes`, `test-check-lanes`, `test-check-units`, `test-checker-deferred`,
  `test-profile`, and `test-checker`'s part 5 of 8;
- `-c sqlite3.c`, and `-fsyntax-only` of the compiler's own source.

**Every command has status 0 in the six rows, and no sanitizer reported anything** (48 commands; a report would be a
file, and each row's count of them is 0). The tests' own counts: 8,008 ranges and 10,000 rounds of the lanes with
none wrong, 853 checks of the units and 3,832 of the deferred checker, 53 of the profile, 210,278 (`x86-64`) and
210,314 (native) of `test-checker`'s part, each with no failure.

The container is not the 9700X: these rows say the piece is clean under the sanitizers, not what it costs.

## Files

- `patches/`: the eight commits (`git format-patch`), on main `c7caeb56b`.
- `scripts/`: `setup.sh`, `job1.sh`, `job2.sh`, `lock.sh`, and `sanitizers.sh` (the cloud container's). What the
  first four call (`build-tree.sh`, `order.sh`, `ab.sh`,
  `tests.sh`, `peak.sh`, `peak-empty.sh`, `musl-common.sh`, `tools/`, `inputs/`) is
  [`executable-pages-2873-2026-11-16`](../executable-pages-2873-2026-11-16/README.md)'s `scripts`, unchanged.
- `tables/`: `abstat`'s table of each A/B, the tests' statuses, the peaks, the start order's counts, each A/B's page
  cache and objects, the series' log, `hello.c`'s calls by `strace`, and the sanitizer rows' steps (`sanitizers.txt`).
- `raw/results.tar.xz`: every run's counts and standard error, the tests' outputs, the start order's body, the builds'
  and the jobs' logs.
