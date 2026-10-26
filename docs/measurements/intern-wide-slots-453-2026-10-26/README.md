# Intern-table slots with 16-byte prefixes (#453), 2026-10-26

[buster14a/buster#453](https://github.com/buster14a/buster/issues/453) proposed buckets of three 20-byte slots (a
16-byte prefix and the id) in place of four 16-byte slots (a 12-byte prefix and the id), so that spellings of up to 15
bytes, rather than 11, are identified by their prefix alone and need no compare with their record (pass B's step 2b).
By occurrence that is 92.0% of `sqlite3.c`'s identifiers and 82.6% of the C library's, against 85.7% and 73.3%.

It doesn't pay. On the 9700X the wide layout took 4.0% more cycles per token in `refine_tokens_64` on `sqlite3.c` and
3.0% more on the C library, back to back and after scalar work alike; the preprocessor's refine phase took 5.0% longer
on `sqlite3.c` and 9.9% longer on `main.c`. A control build of the same code with the old layout stayed within 0.9% of
main everywhere, most of it within 0.2%.

## Trees

| Name | Source | What it is |
| --- | --- | --- |
| `main453` | `e7f386c2` | main |
| `narrow` | `e7f386c2` and `wide-layout.patch`, `BUSTER_INTERN_WIDE_SLOTS` 0 | the layout's code with main's four 16-byte slots: the control for where the code lands |
| `wide` | the same, `BUSTER_INTERN_WIDE_SLOTS` 1 | three 20-byte slots of a 16-byte prefix |

`wide-layout.patch` (made by `wide.py`) puts the layout behind `BUSTER_INTERN_WIDE_SLOTS`: the slots' sizes, the
compare's masks (`0x3DEF`, the prefixes' dwords; `0x0421`, each slot's carry; `0x4210`, the ids' dwords, against
`0x7777`, `0x1111` and `0x8888`), the key (each slot's four prefix dwords spread over the bucket by a `vpermd`, all ones
at the ids' dwords and the padding, against a broadcast of 16 bytes), the slot's store (the 16-byte prefix and the id
apart), pass B's four keys at a time, and `test-refinement`'s 4,096 bucket patterns (three slots of four prefix dwords,
against four of three). With the wide layout, `test-refinement` (its probe patterns, 300,000 spellings and growth at
the pipeline's batch boundaries among them) and `test-files` (the lanes' tables and their merge) passed on the
laptop. Each tree was sent by tar; `source-*.sha256` holds the SHA-256 of each of its files, `binaries.sha256` the
executables' (built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`, `build-*.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each
round took the shared lock on its own (`EXCLUSIVE_OWNER=claude-perf-453`); the lock's waiting messages, which name other
runs, are removed from the logs.

## Method

`refine.sh` (`refine-round.sh`): five rounds; each round, one hold of the lock, runs every tree's six cases as a process
each, pinned to CPU 2, in an order that rotates by round:

- `benchmark-preprocessor --only vectorized` on #408's frozen `sqlite3.c` (SHA-256 `b1dd5d74...`, in
  `~/buster-fast-bench/refine-116-claude/inputs`) and on its frozen `main.c` with `-march=native -Isrc -fwrapv
  -funsigned-char --predefines predefines.h` (#451 part 1's record has that tree's manifest), with
  `SOURCE_DATE_EPOCH=1792454400` and the include-path variables unset: each a warm-up and 21 passes from a fresh
  preprocessor and table, reporting each phase's median;
- `benchmark-refinement --only refine_tokens_64` on `sqlite3.c` and on the C library (Zig 0.14.1's `lib/libc`, 8,983
  `.c` and `.h` files), back to back and with `--after-scalar 100`: 21 passes each.

The tables give the median of the five processes' medians and their range.

## Results

| `benchmark-preprocessor`, refine phase | `main453` | `narrow` | `wide` |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 1.393 ms (1.378-1.412) | 1.391 ms (1.381-1.403) | 1.462 ms (1.457-1.468) |
| `main.c` | 5.128 ms (5.113-5.162) | 5.140 ms (5.109-5.158) | 5.634 ms (5.630-5.639) |

| `refine_tokens_64` | `main453` | `narrow` | `wide` |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, cycles per token | 5.53 (5.53-5.56) | 5.54 (5.53-5.58) | 5.75 (5.74-5.76) |
| `sqlite3.c`, after scalar work | 5.73 (5.63-5.78) | 5.73 (5.61-5.81) | 5.94 (5.93-5.97) |
| `sqlite3.c`, instructions per token | 20.72 | 20.72 | 21.14 |
| C library, cycles per token | 10.98 (10.98-11.11) | 10.99 (10.97-11.01) | 11.31 (11.30-11.33) |
| C library, after scalar work | 11.01 (10.88-11.18) | 10.92 (10.90-10.97) | 11.34 (11.30-11.41) |
| C library, instructions per token | 27.60 | 27.60 | 27.22 |

The other phases didn't move (`refine.log` has them).

## Why

The record compares the prefixes save are fewer than the probes the slots cost. With three slots a bucket fills
sooner: at the same spellings the table has three quarters of the slots and grows at three quarters of the ids (30,720
in its first 16,384 buckets, against 40,960). `sqlite3.c` and its headers intern about 24,000 spellings without growing
either way, at a load of 0.49 against 0.37, which by a Poisson estimate fills a bucket three times as often (18% of
buckets against 6%), each full one sending a probe on to the next bucket's line. `main.c`'s unit interns 56,589 and
grows once in both, ending at 0.58 against 0.43 (25% of buckets full against 10%), and its first growth places fewer
spellings again but comes 10,000 spellings sooner. On the C library, the instructions per token went down (fewer record
compares), and the cycles up. Each probe also builds its key with a `vpermd` in place of a broadcast.

A lower load for the wide layout would take more memory and lines for the same spellings; with the issue's own bound
(skipping 2b altogether had saved 0.18 ms of `sqlite3.c`'s refine phase before its record prefetches went, 0.08 ms of
them since), there is little left for it to win.

## Files

- `wide.py`, `wide-layout.patch`: the layout.
- `builds.sh`, `builds.log`, `build-*.log`: the builds.
- `refine.sh`, `refine-round.sh`, `chain3.sh`, `refine.log`: the measurements.
- `source-*.sha256`, `binaries.sha256`: the identities.
