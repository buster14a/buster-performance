# The executable's read-only data in a sealed, huge-page segment (buster#2886)

buster14a/buster#2886, PR buster14a/buster#3323. Ryzen 7 9700X (`benchpress`), Linux 6.18.50, every run under the
9700X lock (`scripts/lock.sh`, `raw.tar.xz`'s `holds.txt`), Release builds.

- **main:** `1f7ce98f1` (sha256 of the executable `46a9852b…`).
- **head:** main + `scripts/head.patch` (the PR's first commit; `9d2bd921…`).
- **unsealed:** head's file with only the sealed segment's `PF_W` put back (`scripts/unseal.py`): the same bytes but
  one flag, the control that isolates the seal from any other difference between the two builds.

Harness: `ab.sh`, `residual.sh`, `faultmap.sh`, `tools/faultsec.c`, `tools/abstat.c`, `tools/waitall.c` of
[executable-pages-2873-2026-11-16](../executable-pages-2873-2026-11-16/scripts) (fresh copies of each executable,
ABBA rounds, every compile on CPU 2 under `waitall`, counted on CPU 2 as a whole by `perf stat -C 2`). Jobs:
`scripts/job1.sh` (faults by section, main against head, same-copy control), `scripts/job3.sh` (the seal control and
the small commands; `job2.sh` is the same run that the host's full disk broke).

## 1. What a compile writes (cloud VM, main's build)

`scripts/pm.py` under gdb (`scripts/gdbcmds`): at the compile's `exit_group`, each data section's pages present and
those COW'd (pagemap: present and not file-backed). `-c tests/driver/tier1_patterns.c`:

| section | pages | present | written |
| --- | ---: | ---: | ---: |
| `.data.rel.ro` | 3,185 | 305 | 2 (its last page, the C library's RELRO variables, and the page it shares with `.got`) |
| `buster_baked` | 1,636 | 353 | 2 (its first and last, shared with `.data` and `.got.plt`) |
| `.bss` | 55,307 | 18 | 18 |

With the change, `buster_baked` and `.data.rel.ro.buster` read 352 and 224 present, 0 written.

## 2. Faults by section (`tables/res-*`, `-c sqlite3.c` after six warm-up compiles)

| section | main | head |
| --- | ---: | ---: |
| `buster_baked` | 21 (21 windows, 4 ranges) | 4 (3 ranges) |
| `.data.rel.ro` (main) / `.data.rel.ro.buster` + the C library's `.data.rel.ro` (head) | 18 | 5 + 4 |
| `.bss` | 24 | 24 |
| all faults of the process | 5,618 | 5,588 |
| the file in huge pages (page cache) | 14,336 KB | 18,432 KB |

musl's units (`tables/res-*/musl.txt`): units that reach the backend's tables take 26 to 35 fewer faults
(1,017 → 982, 728 → 702, 733 → 704); the small ones 3.

## 3. A/Bs (medians; paired difference B − A, its quartiles, rounds where B < A)

| | kernel cycles | user cycles | user instructions | faults | iTLB misses |
| --- | --- | --- | --- | --- | --- |
| musl, a unit a process, 7 rounds, main → head | 5,298 → 5,084 M, **−4.04%** [−4.37, −3.90] 7/7 | −0.34% 7/7 | same | −35,091 (−4.64%) | +0.74% |
| musl, same control (head against head's own copy) | +0.03% [−0.11, +0.30] 3/7 | −0.01% | same | +0.02% | +0.01% |
| musl, unsealed → head (one build) | 5,572 → 5,389 M, **−3.43%** [−3.79, −2.77] 6/7 | −0.38% 6/7 | same | −30,811 (−4.08%) | −0.16% |
| `-c sqlite3.c`, 21 rounds, main → head | 83.19 → 82.16 M, −1.01% [−3.09, +0.78] 14/21 | −0.10% | same | −29 | −5 |
| `-c sqlite3.c`, unsealed → head | 83.93 → 82.30 M, −1.03% [−2.45, −0.33] 17/21 | −0.48% | same | −27 | +2 |
| `hello.c` `-c`, 100 a count, 11 rounds | 364.6 → 351.5 M, −3.61% 9/11 | +0.43% | same | −5.06% | −0.39% |
| `tiny.c` `-c`, 100 a count, 11 rounds | 238.0 → 229.0 M, −3.83% 10/11 | −2.30% | same | −3.66% | +0.02% |

The empty file's `-fsyntax-only` and a second musl run recorded no counts (the host's disk filled while they ran).

## 4. Not done (left on the issue)

- **`.bss`** (24 faults): 18 pages written, most inside large driver statics (`check_driver_one_unit`'s `pp`,
  `parser` and `deferred`, `check_driver_lanes`) and four of the C library's; the small statics on their own pages
  (the arena flags, `arena_regions`, `x86_zen5_data`'s neighbours) are about 4 or 5 faults.
- **The tables' order:** head's baked tables still take 4 faults in 3 ranges; the remaining faults of the sealed
  segment are ranges with fewer than 64 pages touched, which the exit helper leaves in base pages.
