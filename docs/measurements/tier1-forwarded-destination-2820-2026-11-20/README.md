# A forwarded call's hidden pointer in rdi, Buster #2820

Compiler issue: [#2820](https://github.com/buster14a/buster/issues/2820). Compiler PR:
[#3187](https://github.com/buster14a/buster/pull/3187), head `03aab65985ec5103ad074c043f71261ef1fd860a`, on main
`79f565efee807e69ab6b45447affad96f1010a99` (the base).

A call that passes its function's own hidden result pointer on (#2684: `return f(...);` and a named result's call
initializer) used to return, in Tier 1, into a forwarding slot of the function's own. That slot was then copied where
parameter 0 points: in 8-byte pieces, or by `memmove` past 256 bytes. With #3187 the call's destination is parameter 0's
pointer, which the call's moves put in rdi, and nothing is copied. Tier 0 and the interpreter already did that.

## Host, trees and method

- **Host and trees.** The Ryzen 7 9700X (`benchpress`), Linux 6.18.50, CPU 2 with governor and EPP `performance`,
  clang 23.1.1 and perf 7.2.9 (`record/receipts.txt`). Each tree is a clone of `buster14a/buster` at its commit, built by
  `BUSTER_DEBUG_INFO=0 ./build.sh --config Release`. The executables' SHA-256 values are in `record/receipts.txt`.
- **Harness.** It is #2684's ([hidden-forwarding-2684-2026-11-15](../hidden-forwarding-2684-2026-11-15)), unchanged:
  `kforward.c`, `knamed.c`, `driver.c`, `build-kernels.sh` and `measure-one.sh`. `compile-one.sh` differs only in its
  output path and source tree. `record.sh` is this run's driver.
- **The kernels.**
  - `forwardN`: `fwd(x)` is `return mk(x);`, with N longs (3, 8 and 64: 24, 64 and 512 bytes), 50 M, 20 M and 5 M
    calls.
  - `namedN`: `named(x)` is `struct Big b = mk(x); b.a[0] += 1; return b;`, with 8 and 64 longs.
  - Each kernel is compiled by both trees' `-c -O0 --tier1`, by the base's Tier 0 (`-c -O0`) and by clang `-O0`, and
    linked with its clang `-O2` driver.
- **Measured.**
  - `measure-one.sh` runs a binary once for its checksum. Then it takes `perf stat -r 10` of `cycles:u`,
    `instructions:u`, `ls_bad_status2.stli_other:u` (loads that couldn't take an older store's data) and `task-clock`,
    pinned to CPU 2.
  - Two rounds of every binary, in the order of `record.sh`, give 40 lines (`record/kernels.tsv`, the round first).
  - Every binary of a kernel printed clang's checksum, and every perf status is 0.
- **Lock.** Each build, each kernel build, each measured binary and each compile timing took the 9700X's lock for itself
  alone: 48 holds, all `claude-2820` (`record/holds.txt`). `record/busy.txt` has the busiest processes at each
  measurement.

## Kernels

Millions of user-mode cycles (perf's mean of 10 runs, then the mean of the two rounds), millions of instructions and
millions of failed store forwards:

| kernel | main Tier 1 | this PR Tier 1 | change | Tier 0 | clang -O0 | instructions main / PR | failed store forwards main / PR |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `forward3` | 550.4 | 600.5 | +9.1% | 595.4 | 764.5 | 2450 / 2200 | 100.3 / 0.0 |
| `forward8` | 334.0 | 280.4 | -16.0% | 453.1 | 578.2 | 1780 / 1480 | 252.2 / 0.0 |
| `forward64` | 425.4 | 338.8 | -20.4% | 835.3 | 753.6 | 2240 / 2050 | 9.3 / 5.0 |
| `named8` | 379.4 | 276.0 | -27.3% | 525.4 | 594.7 | 1880 / 1580 | 266.6 / 61.3 |
| `named64` | 431.1 | 342.6 | -20.5% | 827.8 | 795.9 | 2265 / 2075 | 14.7 / 5.1 |

- **64 and 512 bytes.** The copy's loads and stores are gone. Its loads that failed to take the callee's stores' data
  (252 M and 267 M at 64 bytes) go with them, and cycles fall 16% to 27%.
- **24 bytes reads 9.1% slower, one cycle a call (12.0 against 11.0), with 10% fewer instructions and no failed store
  forward.** The base's Tier 0 forwards too and reads the same (595.4). #2684's record has the same sign at that size:
  Tier 0's forwarding against Tier 1's copy, 634.3 against 555.5. So it is the forwarded shape at 24 bytes, not this
  change's code. This run doesn't say why. The two rounds agree within 0.01% for both trees. Code placement isn't
  controlled, and the kernel's loop sits at another address in each tree.

## Compile time

`-c --lanes 1` of `sqlite3.c` (3.53.4's amalgamation, SHA-256 `b1dd5d74…`), pinned to CPU 2, `perf stat -r 5` each
(`record/compile.tsv`):

| tier | main cycles | this PR cycles | change | main instructions | this PR instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| `--tier1` | 3,292.3 M | 3,295.7 M | +0.10% | 8,094.5 M | 8,096.1 M (+0.02%) |
| Tier 0 | 585.5 M | 585.8 M | +0.05% | 1,332.5 M | 1,332.5 M |

`sqlite3.c` has no forwarded call. Its `--tier1` instructions grow by 1.5 M (+0.02%): the test of each call's
destination, in selection and in the certificate.

## Objects (cloud container)

These were compiled in a cloud container with Develop builds of both trees (`cloud/objects.sh`). Each unit was built with
`--tier1 -O2 -march=znver5 --lanes 1 -w`.

- **Lua 5.4.8's 34 units and SQLite 3.54.1's amalgamation** (fetched from lua.org and sqlite.org): the 35 objects are the
  same bytes on both sides (`cloud/objects-*.tsv`). Neither has a forwarded result.
- **The compiler's own `main.c`** (`-c --tier1 --lanes 2 -march=native -Isrc -fwrapv -funsigned-char
  -fno-strict-aliasing`): 11 of its 408 functions are smaller and none larger. `.text` goes from 1,793,534 to 1,792,910
  bytes, from `arena_reserve` −115 to `write_chunk_outlined` −25.
