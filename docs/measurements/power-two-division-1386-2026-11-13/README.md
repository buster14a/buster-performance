# Signed power-of-two division and pointer differences, Buster #1386

Compiler issue: [#1386](https://github.com/buster14a/buster/issues/1386). Compiler PR:
[#2679](https://github.com/buster14a/buster/pull/2679).

The head writes a signed `/` or `%` by a positive constant 2^k (`int`, `long`) as a shift sequence instead of `idiv`:

- `x / 2^k` is `(x + ((x >> (W - 1)) & (2^k - 1))) >> k`;
- `x % 2^k` is `x - ((x + ((x >> (W - 1)) & (2^k - 1))) & -2^k)`.

It also writes a pointer difference by a power-of-two element size as an arithmetic shift, and by a size of 1 as
nothing. The unsigned half of #1386 (`shr` and `and`) was #1592's, already on main.

## Sources

- Main: `b7a95eedbe16fbd8434654f192f8f7aab76c56e5`.
- Head: `d60da4566ede7e8612932550da69f3adbf26a339`, #2679's first commit. Its second commit,
  `65b60d01d1b4a936cf77dd9acb3143ea0fd09423`, changes two test files (`c_check_power_divmod_test.c` and
  `c_check_program_test.c`) and no compiler code; it was not measured.

Each tree on the host is `git archive` of its commit, built with `BUSTER_DEBUG_INFO=0 ./build.sh` (Release, the
host's native `znver5` path), one lock hold per build. `manifests/` has each commit's `git archive` manifest, the
host trees' manifests (taken under the lock; build outputs, `build.log` and the copy's `COMMIT` note left out) and
their comparison. The compilers' SHA-256 are in `results/ab.txt` and `results/compile.txt`.

## Host

The Ryzen 7 9700X (`benchpress`), CPU 2. `results/host.txt` has the kernel, governor, EPP, THP, clang, CMake, Ninja
and perf versions, taken under the lock.

## Method

Every command ran under the 9700X's lock, one hold per run, through `harness/lock.sh`. Each hold appends the
holder's line to `results/holds.txt` and the busiest processes and the load, before and after, to
`results/busy.txt`.

**Kernels** (`harness/kernels.c`): each sums over an array of 4,096 elements. `harness/driver.c`, built by clang
`-O2`, calls each one 20,000 times and prints the milliseconds. `harness/ab.sh` builds `kernels.c` with main's and
head's compilers at Tier 0 (`-c`) and Tier 1 (`-c --tier1`), and with clang at `-O0` and `-O2 -fno-vectorize
-fno-slp-vectorize`, links each with the same `driver.o` (one hold), then runs 11 rounds. Each round is a hold of its
own and runs every binary once per kernel, interleaved, pinned to CPU 2 (`results/runs.txt`).

**Compile** (`harness/compile-ab.sh`): `-c sqlite3.c` from CI's frozen corpus (`preprocessor-391e729af658`) with CI's
options, less `--no-default-config`, which `-c` doesn't take. One hold builds each compiler's Tier 0 and Tier 1
objects and counts their sizes and `div`/`idiv` instructions. Then `perf stat -r 11` of each compiler, pinned to
CPU 2, alternated twice (main, head, main, head), each a hold of its own.

## Kernel results

Milliseconds for 20,000 calls, best/median/worst of 11 rounds (`results/ab.txt`):

| kernel | main Tier 0 | head Tier 0 | main Tier 1 | head Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `s += p[i] / 16u` | 29.7/30.0/31.5 | 29.7/29.8/31.7 | 15.4/15.6/18.9 | 15.4/16.0/17.3 | 37.1/37.1/37.5 | 11.1/11.1/11.2 |
| `s += p[i] % 64u` | 29.7/29.7/30.3 | 29.7/29.7/31.0 | 15.5/15.5/15.6 | 15.5/15.5/15.6 | 37.1/37.2/38.8 | 11.1/11.1/11.3 |
| `s += p[i / 8 * 8 + i % 8]` | 59.2/59.3/59.7 | 59.2/59.2/59.7 | 26.8/26.8/27.5 | 26.8/26.8/28.7 | 42.1/42.3/42.7 | 14.7/14.7/14.8 |
| `int`: `s += p[i] / 16` | 89.7/89.7/90.4 | 59.2/59.2/59.7 | 29.7/29.7/29.9 | 29.7/29.7/30.0 | 92.7/93.4/94.1 | 21.3/21.3/21.5 |
| `int`: `s += p[i] % 64` | 89.7/89.7/90.4 | 41.1/41.1/41.4 | 27.8/27.8/28.1 | 27.6/27.6/27.8 | 93.0/94.1/97.4 | 24.9/24.9/25.0 |
| `long`: `s += p[i] / 8` | 152.2/152.2/153.1 | 44.4/44.5/44.8 | 24.8/24.8/25.0 | 23.3/23.3/23.5 | 134.9/135.1/139.0 | 21.3/21.3/22.1 |
| `s += p[i] - base` | 104.0/104.0/104.6 | 31.8/31.8/36.5 | 26.5/26.5/28.3 | 16.5/16.6/18.1 | 44.5/44.5/44.9 | 14.9/14.9/15.0 |
| `unsigned char`: `s += p[i] / 16 + p[i] % 16` | 180.4/180.5/181.5 | 67.2/67.2/68.1 | 51.6/51.6/52.0 | 51.6/51.7/52.0 | 179.2/179.2/179.5 | 15.8/15.8/15.8 |
| `unsigned long`: `s += p[i] * 8 + 1` | 40.1/40.1/40.3 | 40.1/40.1/44.1 | 16.4/16.5/17.3 | 16.1/16.1/16.2 | 37.5/37.5/37.7 | 18.4/18.4/18.4 |
| `double`: `s += p[i] * 2` | 51.4/51.4/51.4 | 51.4/51.4/51.4 | 38.6/38.7/38.7 | 38.6/38.7/38.7 | 176.0/176.0/176.2 | 29.1/29.1/29.3 |

All six binaries print the same checksum. In Tier 0, the head's signed and pointer kernels take 0.29 to 0.66 times
main's median time, and each is faster than clang -O0's. The unsigned kernels, and the last two, which divide nothing,
are main's. Tier 1's are main's, within their spread, or faster: its pointer difference is `sub; sar $3`, where it was
the bias sequence.

The last two kernels are [#2678](https://github.com/buster14a/buster/issues/2678)'s, not #1386's: an `int` constant
beside an `unsigned long` or a `double` operand, which Tier 0 converts at run time (`mov; movslq`, `mov; cvtsi2sd`).
So is the cause of the third kernel's gap to clang -O0: its `* 8`.

## Compile results

COMPILE-RESULTS

## Limitations

- A Tier 0 kernel's time comes in whole cycles per iteration (one cycle is 14.8 ms of 81.92 M iterations here) and
  moves with code placement. In an exploratory run of the same main objects, linked with an earlier driver, the third
  kernel took 44.5 ms rather than 59.2.
- The head's Tier 0 pointer-difference kernel is bimodal: 31.8 ms in most rounds, up to 36.5.
- The exploratory runs before this record, which held the lock across a whole A/B, are not part of it. They gave the
  same numbers from objects with the same SHA-256.
- The correctness tests listed in #2679 ran in a cloud container, not on this host.
- The logs leave out the lines `exclusive.sh` printed while waiting for other sessions' holds (their commands, titles
  and links): `grep -v -E '^exclusive.sh: waiting|^  (title|link|pull request):'`. Every holder's command was one
  line.

Original material in this directory: Apache-2.0 WITH LLVM-exception.
