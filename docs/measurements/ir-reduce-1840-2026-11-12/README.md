# buster#1840's reductions: compile time and machine rows

buster#1840's reductions (buster#2490) add the IR's `reduce` intrinsic kind. Clang's `__builtin_reduce_*` rows of
doublewords and quadwords decode to it, and Tier 1 selects the same halvings back. A 64-byte doubleword reduction has
eight records, so a Tier 1 node's room (`BUSTER_TIER1_SELECT_RECORDS_PER_NODE`) grew from 6 to 8. This records the
compile-time check of that change and the machine rows before and after.

## Compile time

- **Host:** benchpress (AMD Ryzen 7 9700X). Each build and each `time-runs` took one hold of
  `~/buster-fast-bench/exclusive.sh`, and the timings were pinned to CPU 2 (`time.sh`).
- **Base:** main `a221f6332`. **Head:** `ir/1840-reduce` `fbbb7bd8c`. Both were built `BUSTER_HOST_ARCH=znver5
  BUSTER_DEBUG_INFO=0`.
- **Command:** `time-runs --runs 11 --warmups 2`, alternating the two compilers, each compiling the head's
  `src/buster/compiler/main.c` with `-c -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`, with and
  without `--tier1` (`time-tier1.txt`, `time-tier0.txt`).

| Compile | Base median | Head median | Head against base |
| --- | ---: | ---: | ---: |
| `--tier1 -c main.c`, wall | 1003.979 ms | 1005.076 ms | +0.11% |
| `--tier1 -c main.c`, user cycles | 5209.1 M | 5222.8 M | +0.26% |
| `-c main.c`, wall | 680.337 ms | 680.590 ms | +0.04% |
| `-c main.c`, user cycles | 3435.8 M | 3437.6 M | +0.05% |

Both differences are within the runs' spread (the `--tier1` walls range 1002.0 to 1006.9 ms for base and 1003.8 to
1009.8 ms for head). The instructions retired are equal to 0.002%.

## Machine rows

`machine-rows.txt`. Both compilers (Debug builds) compiled the head's sources at `--tier1 -march=znver5`:

| Unit | Rows before | Rows after |
| --- | ---: | ---: |
| `main_unit_frontend.c` | 15 | 6 |
| `main_unit_backend.c` | 193 | 162 |

`test-checker-driver`'s machine-rows unit goes from 13 rows to 9.

Every form the reductions emit already had its Zen 5 row; none was measured here.
