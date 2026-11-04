# Tier 1's inlining of the SIMD intrinsic wrappers (#1282), 2026-11-04

Measurement record for [buster14a/buster#1282](https://github.com/buster14a/buster/issues/1282) and
[PR #1324](https://github.com/buster14a/buster/pull/1324): the compiler built by clang, and self-hosted by Tier 0, by
Tier 1 without inlining and by Tier 1 with it, each running the lexer's vector workload on the Ryzen 7 9700X. It is the
issue's "Tier 0, Tier 1 and clang on a vector workload" record.

## Tree, host and builds

- Source: PR #1324's head `e6c4fc3c668678a3e552dafac3b48fe3453fad33` (the inliner, SROA's options and `--tier1`'s
  inlining, before its later merge of `main`, which changes none of them).
- Host: `benchpress`, AMD Ryzen 7 9700X, clang 23.1.1 (`raw/environment.txt`). Every build, unit compile and
  measurement took the shared lock (`~/buster-fast-bench/exclusive.sh`) per run; the measurements ran pinned to CPU 2
  (`taskset -c 2`). The lock's wait notices, which name other sessions' and CI jobs' runs, are left out of `raw/`.
- `clang`: `./build.sh` with `BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0` (`raw/build.log`).
- The three self-hosts follow `tools/ci/selfhost.c`'s bootstrap: every unit of `build.sh print-sources`
  (`raw/sources.txt`) compiled separately by the clang-built compiler with `--lanes 1` and `build.sh print-compile-flags`
  less `-O3`, `-Wall` and `-Werror` (`raw/flags.txt`), linked by `clang -no-pie ... -lm -ldl -lpthread`:
  - `tier0`: no tier option (Tier 0).
  - `tier1-noinline`: `--tier1 --tier1-report --tier1-no-inline`.
  - `tier1`: `--tier1 --tier1-report`.
- Harnesses: `bench-1282.sh` (builds, self-hosts, `benchmark-lexer src`) and `time-1282.sh` (`test-lexer`'s wall time,
  three rounds, the four builds interleaved in each). `bench-1282.sh`'s own `test-lexer` timings used `bc`, which
  benchpress doesn't have, so its `timings.tsv` recorded exit codes alone; `time-1282.sh` replaced them.

## `benchmark-lexer src`

786 files, 41,529,578 bytes, 5,795,124 tokens; 21 interleaved passes, medians, cycles/B with min-max
(`raw/*-benchmark-lexer.log`). `c_tokenize` is the lexer's AVX-512 path, written with `_mm512_*` intrinsics;
`c_tokenize_scalar` its scalar twin, which has no wrappers to inline.

| Build | `c_tokenize` | cycles/B | instructions/B | IPC | `c_tokenize_scalar` | cycles/B |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| clang -O3 | 6.304 ms | 0.841 [0.840-0.847] | 3.004 | 3.57 | 64.718 ms | 8.638 |
| Tier 0 | 959.009 ms | 128.028 [127.643-128.039] | 129.348 | 1.01 | 217.739 ms | 29.065 |
| Tier 1, no inlining | 1039.495 ms | 138.835 [138.613-138.854] | 135.117 | 0.97 | 187.868 ms | 25.081 |
| Tier 1, inlining | **209.152 ms** | **27.914** [27.912-27.919] | 43.795 | 1.57 | 185.949 ms | 24.816 |

- Inlining makes Tier 1's vector lexer **4.97x** faster (138.8 to 27.9 cycles/B) and 3.1x fewer instructions per byte;
  it is now 4.6x faster than Tier 0's, where without inlining it was 8% slower.
- The scalar twin is unchanged (25.1 and 24.8 cycles/B), as it should be: it calls no wrapper.
- Tier 1's vector lexer is still 33x clang -O3's. The rest is Tier 1's code generation, not the wrappers' calls: the
  non-inlined functions' vector arguments and results through frame objects at entry and return, spills and moves.

## `test-lexer` wall time

Whole process, `taskset -c 2`, three rounds with the four builds interleaved in each (`time-1282.sh`,
`raw/test-lexer.tsv`); every run exited 0.

| Build | round 1 | round 2 | round 3 | median |
| --- | ---: | ---: | ---: | ---: |
| clang -O3 | 2.932 s | 2.931 s | 2.940 s | 2.932 s |
| Tier 0 | 59.417 s | 58.307 s | 58.776 s | 58.776 s |
| Tier 1, no inlining | 59.637 s | 59.264 s | 59.295 s | 59.295 s |
| Tier 1, inlining | 17.602 s | 17.598 s | 17.600 s | **17.600 s** |

- Inlining makes the Tier 1 self-host's `test-lexer` **3.37x** faster (59.3 s to 17.6 s); it is 3.34x faster than
  Tier 0's, and 6.0x clang -O3's.

## The self-hosts' `--tier1-report`

Summed over the 42 units (`raw/tier1*-report.txt`, a line per unit):

| Build | functions | Tier 1 compiled | unsupported (Tier 0's) | internal / resource failures | inlined calls | records |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Tier 1, no inlining | 32,847 | 32,740 | 107 | 0 / 0 | 0 | 8,692,141 |
| Tier 1, inlining | 32,847 | 32,755 | 92 | 0 / 0 | 37,323 | 8,865,107 |

The wrappers' own bodies are still compiled (each is a function of its unit), so the records grow by 2% with the
inlined copies. The self-hosts' compile times are not recorded: each unit's run waited for the lock among CI jobs and
other sessions.

## Limitations

- One host, one head, one workload (the lexer over the repository's sources). Not a measure of Tier 1's code beyond
  the wrappers' calls.
- `test-lexer`'s times are whole processes (its fixtures and its corpus check), three rounds each.
