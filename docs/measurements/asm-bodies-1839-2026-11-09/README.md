# Asm bodies against their helpers — #1839, 2026-11-09

Source: [buster#1866](https://github.com/buster14a/buster/pull/1866), for
[buster#1839](https://github.com/buster14a/buster/issues/1839).

#1866 places asm statements in their callers as Tier 0 asm bodies (the owner's
decision on [buster#1447](https://github.com/buster14a/buster/issues/1447#issuecomment-6736401463),
item 2). Before it, each statement that wasn't a Tier 0 row was a call of an
out-of-line helper `.Lbuster_asm_N`. This record compares the hot loops of six
such statements across three builds:
- head's asm bodies;
- head with `--helper-forms=asm` (the helpers, from the same compiler);
- base main.

## Runs

All runs are on `benchpress` (Ryzen 7 9700X), under the shared host lock
(`~/buster-fast-bench/exclusive.sh`), each process pinned with `taskset -c 2`,
wall time from `date +%s%N`.

1. **First head**, 2026-11-09 10:20–11:50 UTC (`run.sh`, `run.log`,
   `kernels.tsv`, `compile.tsv`, `summary.txt`, `sizes.txt`):
   - base `cb608c1f616f` (main) and head `11dde41529720ce3e491f0396648f327aa587a4d`,
     both built on benchpress by `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`
     (`build-base.log`, `build-head.log`; host clang 23.1.1);
   - 11 rounds, each running the three builds of a kernel in turn;
   - `-c` of `src/buster/compiler/main.c` (`-march=native -Isrc -fwrapv
     -funsigned-char -fno-strict-aliasing`) and of `kernels.c`, base and head
     alternately, 11 rounds;
   - text bytes and `call` instructions of each build's `kernels.o`.
2. **Second head**, 2026-11-09, one lock hold (`run2.sh`, `run2.log`,
   `kernels2.tsv`, `compile2.tsv`):
   - head `1bfcb90`, the commit that passes register operands as the body's
     call arguments;
   - binary built in the session's container by `BUSTER_HOST_ARCH=znver5
     BUSTER_DEBUG_INFO=0 ./build.sh` (Ubuntu clang 23.1.6), sha256
     `77a00057dd93316958e09dd7a6de51c4447c18ae311f7da20b71cb857a71bb0d`, copied
     as `head2/build/compiler`;
   - compared with run 1's base, and with `head2 --helper-forms=asm` as the
     helpers;
   - 7 rounds; `main.c` compiled from the base tree's source by both;
   - `perf stat -e cycles,instructions,ls_bad_status2.stli_other` of the shift
     kernel by head2 and its helpers.

The kernels are `kernels.c` (sha256
`043774e1dbc4d5c2438434e370d8b9ae54cb3ab1f0f80131dfd01c089d5deb5c`), each a loop
around one asm statement:
- `rdtsc` (20M iterations);
- `cpuid` with four fixed outputs (2M);
- a flag output `=@ccz` (100M);
- `roll %%cl` with a `"c"` count (100M);
- x87 `fsqrt` on `"+t"` (20M);
- `mulq` with `"=a"`/`"=d"` (100M).

Every build's output matched before timing.

## Results

Medians in milliseconds; min and max in the TSVs.

| Kernel | base | helpers | head 11dde41 | head 1bfcb90 |
|---|---:|---:|---:|---:|
| rdtsc | 138.0 | 138.2 | 138.1 | 138.2 |
| cpuid | 52.9 | 52.9 | 52.5 | 51.5 |
| flag output | 101.4 | 101.4 | 76.3 | **62.9** |
| `"c"` shift | 113.6 | 113.6 | **127.4** | **64.1** |
| x87 fsqrt | 295.9 | 295.8 | 294.3 | 293.4 |
| mulq | 127.8 | 127.8 | 105.5 | **77.4** |

- **The first head's shift regression.**
  - Its body loaded each register operand rsp-relative from the operand block, right after the lowering stored it there through another base register.
  - `perf stat` (`run.log` of the investigation is in the PR comment; the second run's counts are in `run2.log`) measured 701M cycles against the helper's 623M, with 99.3M `ls_bad_status2.stli_other` (store-to-load interlock failures) against 6.1M.
  - 1bfcb90 passes those operands as the body's call arguments in their registers: 351M cycles and 4.3M interlock failures, against the helper's 623M and 6.1M.
- **Code:** the kernels' text is 2,073 → 1,872 bytes and their `call`s 23 → 17 at the first head.
- **Compile time:** `-c` is unchanged.
  - `main.c`: 2,195.7 → 2,187.4 ms (run 1), 2,196.7 → 2,189.3 ms (run 2).
  - `kernels.c`: 4.01 → 4.01 ms.

## Limitations

- Single-threaded kernels of one statement each, which isolate the statement's
  cost. rdtsc, cpuid and x87 are dominated by the instructions' own latency.
- Run 2's head binary was built by the container's clang 23.1.6, not on
  benchpress. Its compile times are a sanity check, not an A/B of the same
  toolchain; run 1's are.
